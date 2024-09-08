extends Area2D
class_name Enemie_health_component

signal isDamaged
signal isDead

@export var health: int = 5
@onready var particles: Node = $"../particles"
@onready var collision: CollisionShape2D = $"../CollisionShape2D"
@onready var health_collision: CollisionShape2D = $CollisionShape2D
@onready var dead_clip: AudioStreamPlayer2D = $"../Sounds/EnemieDeadClip"
var is_dead: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var enemie_hit_component = $"../HitComponent"
	enemie_hit_component.playerHited.connect(on_player_hit)
	area_entered.connect(hit)

func hit(area):
	if area is Area_bullet:
		health -= area.damage
		area.bullet_hit(area.removeOnHit)
		check_heal()
		show_damage_particles()
		isDamaged.emit(area.global_position)
	if area is Area_shield:
		health -= area.damage
		check_heal()
		show_damage_particles()
		isDamaged.emit(area.global_position)
		
func on_player_hit():
	if not is_dead:
		enemie_dead()

func check_heal():
	#! revisar esta logica, si es menos de 0 no muere
	if health <= 0 and not is_dead:
		is_dead = true
		enemie_dead()
		
func enemie_dead() ->void:
	call_deferred("_deferred_disable_collision")

	if !dead_clip.playing:
		dead_clip.play()
	isDead.emit()
	Signals.emit_signal("EnemieDead") # Señal global
	show_dead_particles()
	
func _deferred_disable_collision() -> void:
	collision.disabled = true
	health_collision.disabled = true
	
func show_dead_particles() -> void:
	var particle = particles.find_child("dead_GPUParticles2D")
	particle.one_shot = true 
	particle.emitting = true
	
func show_damage_particles() -> void:
	particles.find_child("damaged_GPUParticles2D").emitting = false  # Reinicia la emisión si ya estaba activa
	particles.find_child("damaged_GPUParticles2D").one_shot = true   # Asegúrate de que solo se emita una vez
	particles.find_child("damaged_GPUParticles2D").emitting = true   # Inicia la emisión de partículas

func _on_dead_gpu_particles_2d_finished() -> void:
	get_parent().call_deferred("queue_free")
