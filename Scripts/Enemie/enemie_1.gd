extends CharacterBody2D

@export var SPEED: float = 20.0
@export var knockback_strength = 1000

@onready var player : CharacterBody2D = $"../Nave"
@onready var sprite : Sprite2D = $Sprite2D
@onready var sprite2 : Sprite2D = $Sprite2D2
@onready var sprite3 : Sprite2D = $Sprite2D3
@onready var sprite4 : Sprite2D = $Sprite2D4
@onready var tweenFlash : Tween

var sprites : Array
var selectedSprite : Sprite2D
var isDead = false
var distance_to_player
var direction : Vector2
var angle_to_player : float

func _ready() -> void:
	sprites.append(sprite)
	sprites.append(sprite2)
	sprites.append(sprite3)
	sprites.append(sprite4)

	var random_index = randi_range(0, sprites.size() - 1)
	var selected_sprite = sprites[random_index]
	selected_sprite.visible = true
	selectedSprite = selected_sprite

func _physics_process(_delta: float) -> void:
	move_and_slide()
	move_to_player()

func move_to_player():
	if isDead:
		return
		
	distance_to_player = position.distance_to(player.position)
	
	if distance_to_player > 10.0:
		direction = (player.position - position).normalized()
		velocity = direction * SPEED
		position += velocity * get_process_delta_time()
		
		# Ajustar el ángulo del sprite para que apunte hacia el jugador
		angle_to_player = (player.position - position).angle() + 1.6 # ajuste del sprite
		selectedSprite.rotation = angle_to_player
	else:
		velocity = Vector2.ZERO

	
func _on_health_component_is_damaged(_damage_origin: Vector2) -> void:
	# Calcula la dirección del knockback
	if !isDead:
		# mejorar el nockup

		# TEMPORAL
		SPEED = 5.00
		await get_tree().create_timer(0.1).timeout
		SPEED = 20.0
			
		#var knockback_direction = (position - damage_origin).normalized()
		#
		#var new_position = position + (knockback_direction * knockback_strength * get_process_delta_time())
		#var tween := create_tween()
		## Anima el nodo hacia la nueva posición usando Tween
		#tween.tween_property(self, "position", new_position, 0.2)

func _on_health_component_is_dead() -> void:
	isDead = true

func _on_health_component_is_hited() -> void:
	tweenFlash = get_tree().create_tween()
	tweenFlash.tween_property(
		selectedSprite.material, 
		"shader_parameter/flash_modifier", 
		0.8,
		0.2,
	)
	tweenFlash.chain().tween_property(
		selectedSprite.material, 
		"shader_parameter/flash_modifier", 
		0.0,
		0.2,
	)
