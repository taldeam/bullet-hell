extends CharacterBody2D

@export var SPEED = 400.0
@onready var joystick_left : VirtualJoystick = $"../Test/UI/Virtual joystick left"
@onready var joystick_right : VirtualJoystick = $"../Test/UI/Virtual joystick right"
@onready var sprite : Sprite2D = $Sprite2D
var move_vector := Vector2.ZERO

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
		
	move_and_slide()
