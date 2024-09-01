extends Area2D
class_name Player_health_component

@export var playerHealth : int = 5
@onready var playerHealthVar : TextureProgressBar = $"../../UI2/TextureProgressBar"

func _ready() -> void:
	area_entered.connect(hit)

func hit(area):
	if area is Enemie_hit_component:
		playerHealth -= area.damage
		playerHealthVar.set_value_no_signal(playerHealth)
		checkPlayerHealth(playerHealth)
		
func checkPlayerHealth(playerHealth):
	if playerHealth <= 0:
		get_tree().paused = true
		$"../../UI2/Panel".visible = true
