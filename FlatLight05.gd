extends Control

@export var joystick_deadzone := 0.1

var touch_position := Vector2.ZERO
var joystick_base_position := Vector2.ZERO

signal direction_changed(direction: Vector2)

func _ready():
	joystick_base_position = position  # Corregido: Usar position en lugar de rect_position

func _input(event):
	if event is InputEventScreenTouch or event is InputEventScreenDrag:
		if event.pressed:
			touch_position = event.position
		else:
			touch_position = Vector2.ZERO
		emit_signal("direction_changed", get_joystick_direction())

func get_joystick_direction() -> Vector2:
	var joystick_vector = touch_position - joystick_base_position
	var joystick_direction = joystick_vector.normalized()
	
	if joystick_vector.length() < joystick_deadzone * size.x:  # Corregido: Usar size en lugar de rect_size
		joystick_direction = Vector2.ZERO
	
	return joystick_direction
