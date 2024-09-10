extends Area2D
class_name Player_health_component

@export var playerHealth : int = 5
@onready var playerHealthVar : TextureProgressBar = $"../../UI2/TextureProgressBar"
@onready var sprite : Sprite2D = $"../mainSprite"
@onready var collision : CollisionShape2D = $CollisionShape2D
@onready var safeModeTimer : Timer = $"../SafeMode"
@onready var camera: Camera2D = $"../Camera2D"
@onready var playerShield : GPUParticles2D = $"../Escudo"

var cameraShakeNoise : FastNoiseLite

func _ready() -> void:
	area_entered.connect(hit)
	cameraShakeNoise = FastNoiseLite.new()

func hit(area):
	if area is Enemie_hit_component && !playerShield.visible:
		playerHealth -= area.damage
		playerHealthVar.set_value_no_signal(playerHealth)
		checkPlayerHealth(playerHealth)
		flash()
		var camera_tween: Tween = get_tree().create_tween()
		camera_tween.tween_method(startCameraShake, 15.0, 1.0, 0.5)
		
func checkPlayerHealth(playerHealth):
	if playerHealth <= 0:
		get_tree().paused = true
		$"../../UI2/PanelDied".visible = true

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
func startCameraShake(intensity: float):
	var cameraOffset = cameraShakeNoise.get_noise_1d(Time.get_ticks_msec()) * intensity
	camera.offset.x = cameraOffset
	camera.offset.y = cameraOffset
	
func _on_safe_mode_timeout() -> void:
	collision.set_deferred("disabled", false)
