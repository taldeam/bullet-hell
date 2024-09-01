extends Area2D
class_name Enemie_hit_component

signal playerHited

@export var damage : int = 1
@onready var collision_shape : CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	area_entered.connect(hit)

func hit(area):
	if area is Player_health_component:
		collision_shape.disabled = true
		playerHited.emit()
