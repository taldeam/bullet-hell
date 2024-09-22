extends Sprite2D
class_name Bullet

var SPEED: float = 600.0
var damage: int = 1
var direction: Vector2 = Vector2.ZERO
var spriteScale: float
var originalScale: Vector2
var collisionScale: float
var parentPosition : Vector2
var isNaveAliada : bool = false
var spriteTexture = load("res://Assets/efectos nave/Laser Sprites/16.png")	

var random_bullet_sprite : Array = [
	"res://Assets/efectos nave/Laser Sprites/01.png",
	"res://Assets/efectos nave/Laser Sprites/02.png",
	"res://Assets/efectos nave/Laser Sprites/03.png",
	"res://Assets/efectos nave/Laser Sprites/04.png",
	"res://Assets/efectos nave/Laser Sprites/09.png"
]

var tween : Tween
@onready var bullets_pool: Node = get_tree().root.get_node("mundo/Bullets_pool")

func _enter_tree() -> void:
	tween.bind_node(self)
	tween.stop()
	tween.play()

	# Escalar la colisión y el sprite
	if collisionScale:
		$Area2D/CollisionShape2D.scale = Vector2(collisionScale, collisionScale)
	if spriteScale:
		self.scale = Vector2(spriteScale, spriteScale)

	# Cambiar el sprite dependiendo de si es una nave aliada
	if !isNaveAliada:
		spriteTexture = load("res://Assets/efectos nave/Laser Sprites/16.png")
		self.scale = Vector2(0.215, 0.215)
		self.texture = spriteTexture
		get_tree().current_scene.get_node("Sounds/ShootClip").play()
	else:
		spriteTexture = load(random_bullet_sprite.pick_random())
		self.texture = spriteTexture

	# Posicionar la bala y rotarla según la dirección
	self.global_position = parentPosition
	rotation = direction.angle()
	

	# Programar la eliminación de la bala
	#remove_bullet()

# Mover manualmente la bala actualizando su posición en cada fotograma
func _physics_process(_delta: float) -> void:
	var movement = direction * SPEED * _delta
	self.global_position += movement  # Mover la bala manualmente


func bind_tween() -> void:
	tween = create_tween().bind_node(self)
	tween.tween_property(self, "scale", Vector2(0.0,0.0), 2)
	tween.stop()
	tween.tween_callback(return_to_pool)  # Devolver la bala al pool

# Tween para eliminar la bala
func remove_bullet():
	tween.stop()
	#if !tween.is_running():
	#tween.tween_property(self, "scale", Vector2(0.0,0.0), 2)
	#tween.tween_callback(return_to_pool)  # Devolver la bala al pool

# Devolver la bala al pool
func return_to_pool() -> void:
	reestart_conditions()
	#get_tree().current_scene.remove_child(self)
	bullets_pool.return_object(self)

# Configurar la dirección de la bala
func set_direction(dir: Vector2) -> void:
	direction = dir.normalized()

# Reiniciar las condiciones de la bala cuando se reutiliza
func reestart_conditions() -> void:
	self.scale = Vector2(0.8, 0.8)
	self.global_position = parentPosition  # Reiniciar posición
	direction = Vector2.ZERO  # Resetear la dirección

func _exit_tree() -> void:
	pass
