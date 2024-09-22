extends Area2D
class_name Area_bullet

@onready var laserTimer : Timer
@onready var bullets_pool: Node = get_tree().root.get_node("mundo/Bullets_pool")
@onready var laserClip : AudioStreamPlayer2D

@export var damage : int = 1
@export var removeOnHit : bool = true
@export var laser_cooldown : int = 15

func _ready() -> void:
	laserClip = self.find_child("laser_clip")
	laserTimer = self.find_child("laserTimer")
	if laserTimer:
		removeOnHit = false
		laserTimer.wait_time = laser_cooldown
		laserTimer.start()
	else: 
		removeOnHit = true

func bullet_hit(remove) -> void:
	if remove:
		self.get_parent().queue_free()

func _shoot_laser():
	var laserAreaTween : Tween = get_tree().create_tween()
	laserClip.play()
	laserAreaTween.tween_property(self, "scale", Vector2(1,1113.74), 2).set_delay(4.49)

func _remove_laser():
	var laserAreaTween : Tween = get_tree().create_tween()
	laserAreaTween.tween_property(self, "scale", Vector2(1,0), 1.5).set_delay(5)

func _on_laser_timer_timeout() -> void:
	_shoot_laser()
	call_deferred("_remove_laser")

## Devolver la bala al pool
#func return_to_pool() -> void:
	#reestart_conditions()
	#bullets_pool.return_object(self.get_parent())
#
## Reiniciar las condiciones de la bala cuando se reutiliza
#func reestart_conditions() -> void:
	#self.get_parent().scale = Vector2(0.8, 0.8)
