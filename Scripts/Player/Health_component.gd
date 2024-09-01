extends Area2D
class_name Player_health_component

@export var playerHealth : int = 5
@onready var playerHealthVar : TextureProgressBar = $"../../UI2/TextureProgressBar"
@onready var sprite : Sprite2D = $"../Sprite2D"
@onready var collision : CollisionShape2D = $CollisionShape2D
@onready var safeModeTimer : Timer = $"../SafeMode"

func _ready() -> void:
	area_entered.connect(hit)

func hit(area):
	if area is Enemie_hit_component:
		playerHealth -= area.damage
		playerHealthVar.set_value_no_signal(playerHealth)
		checkPlayerHealth(playerHealth)
		flash()
		
func checkPlayerHealth(playerHealth):
	if playerHealth <= 0:
		get_tree().paused = true
		$"../../UI2/Panel".visible = true
		
func flash():
	safeModeTimer.start()
	collision.set_deferred("disabled", true)
	#collision.set_disabled(true)
	var tween = get_tree().create_tween()
	# Repetimos la animación de parpadeo 5 veces
	for i in range(5):
		# Encendemos el flash (subiendo el valor)
		tween.tween_property(
			sprite.material, 
			"shader_parameter/flash_modifier", 
			0.7,
			0.2,
		)
		# Apagamos el flash (bajando el valor)
		tween.tween_property(
			sprite.material, 
			"shader_parameter/flash_modifier", 
			0.0,
			0.2,
		)

func _on_safe_mode_timeout() -> void:
	collision.set_deferred("disabled", false)
