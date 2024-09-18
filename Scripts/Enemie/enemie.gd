extends Sprite2D

const SPEED = 30.0
const MIN_DISTANCE = 80.0 # Distancia mínima entre enemigos
const REPULSION_FORCE = 600.0 # Fuerza de repulsión
const CHECK_FREQUENCY = 5 # Actualiza la repulsión cada 1 frame (puedes ajustarlo para mejorar el rendimiento)

@onready var tweenFlash : Tween

var frame_counter = 0

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
	# Solo calcular repulsión cada X frames
	move_to_player(delta)
	#frame_counter += 1
	#if frame_counter % CHECK_FREQUENCY == 0:
		#apply_repulsion_from_enemies()

func set_random_prite() -> void:
	var random_sprite_path = sprites_array.pick_random()  # Pick a random sprite path
	var spriteTexture = load(random_sprite_path)  # Load the texture from the path
	self.texture = texture  # Assign the texture to the Sprite2D 

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
	
# Función optimizada para aplicar la fuerza de repulsión
func apply_repulsion_from_enemies() -> void:
	for enemy in Signals.enemies_in_group:
		if enemy == self:
			continue
		
		# Solo calcular si están dentro de un rango razonable
		var distance_to_enemy = position.distance_to(enemy.position)
		if distance_to_enemy < MIN_DISTANCE * 3: # Solo si están razonablemente cerca
			# Si están muy cerca, aplicar una fuerza de repulsión
			if distance_to_enemy < MIN_DISTANCE:
				var repulsion_dir = (position - enemy.position).normalized()
				var repulsion_force = repulsion_dir * REPULSION_FORCE / distance_to_enemy # Cuanto más cerca, más fuerte la repulsión
				position += repulsion_force * get_process_delta_time() # Ajustar la posición con la repulsión
