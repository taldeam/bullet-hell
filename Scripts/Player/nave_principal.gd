extends CharacterBody2D

@export var SPEED = 200.0
@export var acceleration = 500.0
@export var friction = 50.0
@export var attack_speed : float = 1.0
@export var bullet_damage : int = 1

@onready var shieldEscene : PackedScene = preload("res://escenas/Player/shield_area.tscn")
@onready var bullet_scene : PackedScene = preload("res://escenas/bullet.tscn")
@onready var nave_aliada : PackedScene = preload("res://escenas/Player/nave_aliada.tscn")
@onready var rayo_layer : PackedScene = preload("res://escenas/Player/laser_rayos.tscn")

@onready var joystick_left : VirtualJoystick = $"../UI2/Virtual joystick left"
@onready var joystick_right : VirtualJoystick = $"../UI2/Virtual joystick right"
@onready var sprite : Sprite2D = $mainSprite
@onready var collisionShape : CollisionShape2D = $CollisionShape2D
@onready var shoot_timer : Timer = $ShootTimer

var move_vector := Vector2.ZERO
var last_angle = 0
var sprite_angle_correction = 1.6
var number_of_allies = 0
var allies_actual_attack_speed = 1.0

var aliados_positions: Array[Vector2] = [
	Vector2(-25, 0),
	Vector2(25, 0),
	Vector2(0, -25),
	Vector2(0, 25),
	Vector2(22, 22),
	Vector2(-22, -22),
	Vector2(22, -22),
	Vector2(-22, 22)
]

func _ready() -> void:
	shoot_timer.wait_time = attack_speed
	shoot_timer.start()
	Signals.connect("EnableBuff", _on_power_up_button_buff_type_signal)

func _physics_process(delta: float) -> void:
	# Movimiento basado en el joystick izquierdo
	var direction := joystick_left.output
	if direction != Vector2.ZERO:
		direction = direction.normalized()
		# Aumentar gradualmente el vector de movimiento en la dirección de la entrada
		move_vector = move_vector.move_toward(direction * SPEED, acceleration * delta)
	else:
		# Desacelerar gradualmente cuando no hay entrada
		move_vector = move_vector.move_toward(Vector2.ZERO, friction * delta)
	
	# Mover al personaje
	velocity = move_vector
	move_and_slide()

	# Actualiza la rotación del sprite basado en el joystick derecho
	if joystick_right and joystick_right.is_pressed:
		var joystick_angle = joystick_right.output.angle() + sprite_angle_correction # esto ajusta el sprite
		sprite.rotation = joystick_angle
		last_angle = joystick_angle

func _state_shoot1():
	var bullet_instance = bullet_scene.instantiate()
	bullet_instance.isNaveAliada = false
	# Configurar la dirección de la bala
	var shoot_direction = Vector2.RIGHT.rotated(joystick_right.output.angle())
	bullet_instance.find_child("Area2D").damage = 1
	# Configurar la posición local de la bala (puede que necesites ajustar esto)
	bullet_instance.parentPosition = self.global_position
	# Configurar la dirección de la bala antes de agregarla a la escena
	bullet_instance.set_direction(shoot_direction)
	# Agregar la bala a la escena
	get_tree().current_scene.add_child(bullet_instance)
	
func _on_timer_timeout() -> void: # velocidad de ataque
	if joystick_right and joystick_right.is_pressed:
		_state_shoot1()

func update_attack_speed() -> void:
	if attack_speed <= 0.3:
		Signals.BuffArray[3].state = true
	else:
		attack_speed -= 0.10
		shoot_timer.wait_time = attack_speed

func update_attack_speed_ally() -> void:
	var naves_aliadas_group = get_tree().get_nodes_in_group("naves_aliadas_group")
	allies_actual_attack_speed -= 0.10
	for nave in naves_aliadas_group:
		nave.shoot_timer.wait_time = allies_actual_attack_speed
	if allies_actual_attack_speed <= 0.3:
		Signals.BuffArray[4].state = true

# POWERUPS
func activate_shield() -> void:
	var instance = shieldEscene.instantiate()
	add_child(instance)

func activate_ally_ship() -> void:
	if number_of_allies < 8 and Signals.BuffArray[4].state:
		Signals.BuffArray[4].state = false
	if	aliados_positions.size() > 0:
		var nave_aliada_instance = nave_aliada.instantiate()
		nave_aliada_instance.attack_speed = allies_actual_attack_speed
		nave_aliada_instance.parentPosition = aliados_positions[0]  # Asegúrate de usar la propiedad `position`
		self.add_child(nave_aliada_instance)
		number_of_allies += 1  # Incrementa el número de aliados
		# Elimina la posición después de usarla
		aliados_positions.remove_at(0)  # Usa el índice correcto, aquí eliminas la posición utilizada (índice 0)

func activate_laser() -> void:
	var instance = rayo_layer.instantiate()
	sprite.add_child(instance)

# END POWERUPS

func _on_power_up_button_buff_type_signal(buffType) -> void:
	match buffType:
		"escudo":
			activate_shield()
			Signals.BuffArray[0].state = true
		"laser":
			activate_laser()
			Signals.BuffArray[1].state = true
		"nave":
			activate_ally_ship()
			if number_of_allies >= 8:
				Signals.BuffArray[2].state = true
		"attack_speed":
			update_attack_speed()
		"attack_speed_ally":
			update_attack_speed_ally()
		_:
			pass
