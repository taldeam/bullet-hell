extends Area2D
class_name Enemie_health_component

signal isDamaged
@export var health: int = 20
@onready var particles: GPUParticles2D = $"../particles/GPUParticles2D"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_entered.connect(hit)

func hit(area):
	if area is Area_bullet:
		health -= area.damage
		area.bullet_hit(true)
		check_heal()
		show_damage_particles()
		isDamaged.emit(area.global_position)

func check_heal():
	if health <= 0:
		get_parent().queue_free()

func show_damage_particles() -> void:
	particles.emitting = false  # Reinicia la emisión si ya estaba activa
	particles.one_shot = true   # Asegúrate de que solo se emita una vez
	particles.emitting = true   # Inicia la emisión de partículas
	pass
