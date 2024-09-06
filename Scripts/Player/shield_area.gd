extends Area2D
class_name Area_shield

#! Esta escena necesita de un nodo GPUparticles con nombre Escudo
@export var damage : float = 5
@export var shield : float = 5
@onready var shieldGpu : GPUParticles2D = $"../Escudo"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_entered.connect(hit)
	shieldGpu.set_deferred("emitting", false)
	shieldGpu.set_deferred("visible", false)
	shieldGpu.set_deferred("amount_ratio", 0)
	activeShieldGpu()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func hit(area) -> void:
	if area is Enemie_health_component:
		shield -= 1
		checkShieldHealth()
		
func checkShieldHealth() ->void:
	if shield == 0:
		removeShieldGpu()

func activeShieldGpu() -> void:
	shieldGpu.set_deferred("emitting", true)
	shieldGpu.set_deferred("visible", true)

	var shieldTween : Tween = get_tree().create_tween()
	shieldTween.tween_property(shieldGpu, "amount_ratio", 1, 3)
	
func removeShieldGpu() -> void:
	shieldGpu.set_deferred("emitting", false)
	shieldGpu.set_deferred("visible", false)
	shieldGpu.set_deferred("amount_ratio", 0)
	self.queue_free()
