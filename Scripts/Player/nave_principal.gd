extends CharacterBody2D

@export var SPEED = 400.0
@onready var joystick_left : VirtualJoystick = $"../UI2/Virtual joystick left"
@onready var joystick_right : VirtualJoystick = $"../UI2/Virtual joystick right"
@onready var sprite : Sprite2D = $Sprite2D
var move_vector := Vector2.ZERO
@onready var collisionShape : CollisionShape2D = $CollisionShape2D

func _physics_process(delta: float) -> void:
	# Movimiento basado en el joystick izquierdo
	var direction := joystick_left.output
	
	if direction != Vector2.ZERO:
		direction = direction.normalized()
	
	velocity = direction * SPEED
	
	position += move_vector * SPEED * delta
	
	# Rotation:
	if joystick_right and joystick_right.is_pressed:
		sprite.rotation = joystick_right.output.angle()
	
	_state_shoot1()
	move_and_slide()

func _state_shoot1():
	# Cargar la escena de la bala (Bullet)
	var bullet_scene = preload("res://escenas/bullet.tscn")
	# Instanciar la bala
	var bullet_instance = bullet_scene.instantiate()
	# Configurar la posición de la bala en la posición del HitBoxComponent
	bullet_instance.position = self.position
	
	# Obtener la dirección hacia donde mira el personaje usando is_rotate
	var direction = Vector2.RIGHT
	# Configurar la dirección de la bala
	bullet_instance.set_direction(direction)
	# Agregar la bala a la escena
	get_parent().add_child(bullet_instance)
