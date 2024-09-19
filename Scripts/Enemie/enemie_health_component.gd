extends Area2D
class_name Enemie_health_component

signal isDamaged
signal isDead
signal isHited

@onready var dead_particles = $"../particles/dead_GPUParticles2D"
@onready var enemies_pool: Node = get_tree().root.get_node("mundo/Enemies_pool")
@export var health: int = 3
@onready var particles: Node = $"../particles"
@onready var health_collision: CollisionShape2D = $CollisionShape2D
@onready var hit_collision: CollisionShape2D = $"../HitComponent/CollisionShape2D"

@onready var dead_clip: AudioStreamPlayer2D = $"../Sounds/EnemieDeadClip"
@onready var sprite : Sprite2D = $".."

var is_dead: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
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
		
	isHited.emit()

	
func check_heal():
	#! revisar esta logica, si es menos de 0 no muere
	if health <= 0 and not is_dead:
		is_dead = true
		enemie_dead()
		
func enemie_dead() ->void:
	call_deferred("_disable_collision")

	if !dead_clip.playing:
		dead_clip.play()
	Signals.emit_signal("EnemieDead") # Señal global
	show_dead_particles()
	
func _disable_collision() -> void:
	health_collision.disabled = true
	hit_collision.disabled = true

func show_dead_particles() -> void:
	dead_particles.emitting = true
	await get_tree().create_timer(0.5).timeout
	return_obj_to_pool()
	
func show_damage_particles() -> void:
	particles.find_child("damaged_GPUParticles2D").one_shot = true   # Asegúrate de que solo se emita una vez
	particles.find_child("damaged_GPUParticles2D").emitting = true   # Inicia la emisión de partículas

func _on_hit_component_player_hited() -> void:
	if not is_dead:
		enemie_dead()

func return_obj_to_pool() -> void:
	reestart_conditions() # Aqui se deshabilitan las condiciones del healthcomponent
	var enemie_node = get_parent()
	enemies_pool.return_object(enemie_node)
	
func reestart_conditions() -> void:
	dead_clip.stop()
	health = 3
	is_dead = false
	dead_particles.restart()
	dead_particles.emitting = false
