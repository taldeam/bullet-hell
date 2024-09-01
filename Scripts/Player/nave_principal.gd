extends CharacterBody2D

@export var SPEED = 450.0
@export var acceleration = 1000.0
@export var friction = 200.0

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
		# Aumentar gradualmente el vector de movimiento en la dirección de la entrada
		move_vector = move_vector.move_toward(direction * SPEED, acceleration * delta)
	else:
		# Desacelerar gradualmente cuando no hay entrada
		move_vector = move_vector.move_toward(Vector2.ZERO, friction * delta)
	
	# Mover al personaje
	velocity = move_vector
	move_and_slide()

	# Rotación basada en el joystick derecho
	# Actualiza la rotación del sprite basado en el joystick derecho
	if joystick_right and joystick_right.is_pressed:
		var joystick_angle = joystick_right.output.angle() + sprite_angle_correction # esto ajusta el sprite
		sprite.rotation = joystick_angle
		last_angle = joystick_angle

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
	get_tree().current_scene.add_child(bullet_instance)

func _on_timer_timeout() -> void:
	if joystick_right and joystick_right.is_pressed:
		_state_shoot1()
