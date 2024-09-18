extends CharacterBody2D
class_name Bullet

var SPEED: float = 600.0
var damage: int = 1
var direction: Vector2 = Vector2.ZERO
var spriteScale: float
var collisionScale: float
var parentPosition : Vector2
var isNaveAliada : bool = false

@onready var sprite : Sprite2D = $Sprite2D
@onready var shootClip : AudioStreamPlayer = $"../Sounds/ShootClip"
@onready var collision : CollisionShape2D = $Area2D/CollisionShape2D

func _ready() -> void:
	if collisionScale:
		collision.scale = Vector2(collisionScale, collisionScale)
	if spriteScale:
		sprite.scale = Vector2(spriteScale, spriteScale)
	if !isNaveAliada:
		shootClip.play()
	else:
		var random_sprite_path = "res://Assets/efectos nave/Laser Sprites/01.png"
		var spriteTexture = load(random_sprite_path)
		sprite.texture = spriteTexture
		
	self.global_position = parentPosition
	rotation = direction.angle()
	remove_bullet()
	
func _physics_process(_delta: float) -> void:
	# Mover la bala en la dirección configurada
	velocity = direction * SPEED
	move_and_slide()
	
func remove_bullet():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2(), 2)
	tween.tween_callback(self.queue_free)
	
func set_direction(dir: Vector2) -> void:
	direction = dir.normalized()
