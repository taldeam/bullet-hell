extends CharacterBody2D
class_name Bullet

const SPEED: float = 600.0
const DAMAGE: int = 1
var direction: Vector2 = Vector2.ZERO
var spriteScale: float = 0.45

@onready var sprite : Sprite2D = $Sprite2D
@onready var shootClip : AudioStreamPlayer = $"../Sounds/ShootClip"

func _ready() -> void:
	sprite.scale = Vector2(spriteScale, spriteScale)
	shootClip.play()
	rotation = direction.angle()
	remove_bullet()
	
func _physics_process(delta: float) -> void:
	# Mover la bala en la dirección configurada
	velocity = direction * SPEED
	move_and_slide()
	
func remove_bullet():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2(), 2)
	tween.tween_callback(self.queue_free)
	
func set_direction(dir: Vector2) -> void:
	direction = dir.normalized()
