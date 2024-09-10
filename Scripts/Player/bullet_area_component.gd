extends Area2D
class_name Area_bullet

@export var damage : int = 1
@export var removeOnHit : bool = true
@onready var laserTimer : Timer
@onready var laserClip : AudioStreamPlayer2D

func _ready() -> void:
	laserTimer = self.find_child("laserTimer")
	laserClip = self.find_child("laser_clip")

func bullet_hit(remove) -> void:
	if remove:
		get_parent().queue_free()

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
