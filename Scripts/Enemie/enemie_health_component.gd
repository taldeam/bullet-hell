extends Area2D
class_name Enemie_health_component

signal isDamaged
signal isDead

@export var health: int = 5
@onready var particles: Node = $"../particles"
@onready var collision: CollisionShape2D = $"../CollisionShape2D"
@onready var health_collision: CollisionShape2D = $CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var enemie_hit_component = $"../HitComponent"
	enemie_hit_component.playerHited.connect(on_player_hit)

	area_entered.connect(hit)

func hit(area):
	if area is Area_bullet:
		health -= area.damage
		area.bullet_hit(true)
		check_heal()
		show_damage_particles()
		isDamaged.emit(area.global_position)

func on_player_hit():
	enemie_dead()

func check_heal():
	if health <= 0:
		enemie_dead()
		
func enemie_dead() ->void:
	isDead.emit()
	Signals.emit_signal("EnemieDead") # Señal global
	show_dead_particles()
	if is_instance_valid(collision):
		collision.queue_free()
		health_collision.queue_free()

func show_dead_particles() -> void:
	var particle = particles.find_child("dead_GPUParticles2D")
	particle.one_shot = true 
	particle.emitting = true
	
func show_damage_particles() -> void:
	particles.find_child("damaged_GPUParticles2D").emitting = false  # Reinicia la emisión si ya estaba activa
	particles.find_child("damaged_GPUParticles2D").one_shot = true   # Asegúrate de que solo se emita una vez
	particles.find_child("damaged_GPUParticles2D").emitting = true   # Inicia la emisión de partículas


func _on_dead_gpu_particles_2d_finished() -> void:
	get_parent().queue_free()
