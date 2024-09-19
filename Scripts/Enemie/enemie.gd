extends Sprite2D

@export var SPEED = 40.0

@onready var tweenFlash : Tween
@onready var health_collision: CollisionShape2D = $HealthComponent/CollisionShape2D
@onready var hit_collision: CollisionShape2D = $HitComponent/CollisionShape2D

var sprites_array : Array = [
	"res://Assets/nave y enemigos/ShipsPNG/ship8.png",
	"res://Assets/nave y enemigos/ShipsPNG/ship7.png",
	"res://Assets/nave y enemigos/ShipsPNG/ship6.png",
	"res://Assets/nave y enemigos/ShipsPNG/ship5.png",
	"res://Assets/nave y enemigos/ShipsPNG/ship4.png"
]

func _ready() -> void:
	set_random_prite()
	
func _physics_process(delta: float) -> void:		
	move_to_player(delta)

func set_random_prite() -> void:
	var random_sprite_path = sprites_array.pick_random()  # Pick a random sprite path
	var spriteTexture = load(random_sprite_path)  # Load the texture from the path
	self.texture = spriteTexture  # Assign the texture to the Sprite2D 

func move_to_player(delta: float) -> void:
	var player_position = Signals.player_position
	
	# Calcular la distancia al jugador
	var distance_to_player = position.distance_to(player_position)
	
	# Mover hacia el jugador si está lejos
	if distance_to_player > 15.0:
		var direction = (player_position - position).normalized()
		var velocity = direction * SPEED
		position += velocity * delta # Simplemente actualizar la posición

		# Ajustar el ángulo del sprite para que apunte hacia el jugador
		rotation = (player_position - position).angle() + 1.6 # ajuste del sprite (rotation es una propiedad en Sprite2D)
	else:
		var velocity = Vector2.ZERO

func _on_health_component_is_hited() -> void:
	tweenFlash = get_tree().create_tween()
	tweenFlash.tween_property(
		self.material, 
		"shader_parameter/flash_modifier", 
		0.8,
		0.2,
	)
	tweenFlash.chain().tween_property(
		self.material, 
		"shader_parameter/flash_modifier", 
		0.0,
		0.2,
	)
	
	SPEED = 0
	await get_tree().create_timer(0.1).timeout
	SPEED = 40
