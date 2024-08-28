extends Area2D
class_name Area_enemie_on_range

signal enemieOnRange

@onready var player : CharacterBody2D = get_parent()

var closest_enemy : Area2D = null
var closest_distance = INF

func _ready() -> void:
	area_entered.connect(area_enter)
	area_exited.connect(area_exit)

func area_enter(area):
	if area is Enemie_health_component:
		closest_enemy = area
		print('Enemigo entra')

func area_exit(area):
	if area is Enemie_health_component:
		print('Enemigo sale')

func _physics_process(delta: float) -> void:
	pass
