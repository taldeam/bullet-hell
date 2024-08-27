extends Area2D
class_name Enemie_health_component

@export var health: int = 2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_entered.connect(hit)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func hit(area):
	if area is Area_bullet:
		health -= area.damage
		area.bullet_hit(true)
		check_heal()

func check_heal():
	if health <= 0:
		get_parent().queue_free()
