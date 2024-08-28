extends CharacterBody2D

@export var SPEED = 450.0
@export var FIRE_RATE = 1.0  # Intervalo de disparo en segundos

@onready var joystick_left : VirtualJoystick = $"../UI2/Virtual joystick left"
@onready var joystick_right : VirtualJoystick = $"../UI2/Virtual joystick right"
@onready var sprite : Sprite2D = $Sprite2D
@onready var collisionShape : CollisionShape2D = $CollisionShape2D
@onready var closer_enemie : RayCast2D = $RayCast2D

var move_vector := Vector2.ZERO
var last_angle = 0
var sprite_angle_correction = 1.6

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	# Movimiento basado en el joystick izquierdo
	var direction := joystick_left.output
	
	if direction != Vector2.ZERO:
		direction = direction.normalized()
	
	velocity = direction * SPEED
	
	position += move_vector * SPEED * delta
	
	# Rotación basada en el joystick derecho
	# Actualiza la rotación del sprite basado en el joystick derecho
	if joystick_right and joystick_right.is_pressed:
		var joystick_angle = joystick_right.output.angle() + sprite_angle_correction # esto ajusta el sprite
		sprite.rotation = joystick_angle
		last_angle = joystick_angle
		
	check_closer_enemie()
	move_and_slide()

func check_closer_enemie() -> void:
	var area : Area2D = null
	if closer_enemie.is_colliding():
		area = closer_enemie.get_collider()
	if area is Enemie_health_component:
		# aqui disparará automaticamente
		pass

func _state_shoot1():
	# Cargar la escena de la bala (Bullet)
	var bullet_scene = preload("res://escenas/bullet.tscn")
	# Instanciar la bala
	var bullet_instance = bullet_scene.instantiate()
	# Configurar la posición de la bala en la posición del HitBoxComponent
	bullet_instance.position = self.position
	
	# Obtener el ángulo actual del joystick derecho y convertirlo a dirección
	var shoot_direction = Vector2.RIGHT.rotated(joystick_right.output.angle())
	
	# Configurar la dirección de la bala
	bullet_instance.set_direction(shoot_direction)
	# Agregar la bala a la escena
	get_parent().add_child(bullet_instance)

func _on_timer_timeout() -> void:
	if joystick_right and joystick_right.is_pressed:
		_state_shoot1()
