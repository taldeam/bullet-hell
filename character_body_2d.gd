extends CharacterBody2D

var joystick_direction := Vector2.ZERO

func _ready():
	# Cargar la referencia del joystick
	var joystick = $"../Control"
	joystick.connect("direction_changed", Callable(self, "_on_joystick_direction_changed"))

func _on_joystick_direction_changed(direction):
	joystick_direction = direction
	print("Joystick direction: ", direction)
