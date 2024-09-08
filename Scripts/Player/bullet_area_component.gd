extends Area2D
class_name Area_bullet

@export var damage : int = 1
@export var removeOnHit : bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func bullet_hit(remove) -> void:
	if remove:
		get_parent().queue_free()
