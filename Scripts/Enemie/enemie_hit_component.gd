extends Area2D
class_name Enemie_hit_component

signal playerHited

@export var damage : int = 1

func _ready() -> void:
	area_entered.connect(hit)

func hit(area):
	if area is Player_health_component:
		playerHited.emit()
