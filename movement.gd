extends Node
class_name movement

var speed: float = 32.0
var max_speed: float = 32.0

var character: CharacterBody2D 

func setup(character2d: CharacterBody2D):
	character = character2d
	
	func move(input_vector: Vector2):
		character.velocity = imput_vector.normalized() * speed
		characrer.move_and
# Called when the node enters the scene tree for the first time.
