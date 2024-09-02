extends Area2D
class_name Area_bullet

@export var damage : int = 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func bullet_hit(state) -> void:
	return
	if state:
		get_parent().queue_free()
