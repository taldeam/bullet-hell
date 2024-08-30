extends CharacterBody2D

@export var SPEED: float = 45.0

@onready var player : CharacterBody2D = $"../Nave"
@onready var sprite : Sprite2D = $Sprite2D
@onready var sprite2 : Sprite2D = $Sprite2D2
@onready var sprite3 : Sprite2D = $Sprite2D3
@onready var sprite4 : Sprite2D = $Sprite2D4
var sprites : Array
var selectedSprite : Sprite2D
@export var knockback_strength = 1000
var isDead = false

func _ready() -> void:
	sprites.append(sprite)
	sprites.append(sprite2)
	sprites.append(sprite3)
	sprites.append(sprite4)

	var random_index = randi_range(0, sprites.size() - 1)
	var selected_sprite = sprites[random_index]
	selected_sprite.visible = true
	selectedSprite = selected_sprite

func _physics_process(delta: float) -> void:
	move_and_slide()
	move_to_player()

func move_to_player():
	var distance_to_player = position.distance_to(player.position)
	
	if distance_to_player > 30.0 && !isDead:
		var direction = (player.position - position).normalized()
		velocity = direction * SPEED
		position += velocity * get_process_delta_time()
		
		# Ajustar el ángulo del sprite para que apunte hacia el jugador
		var angle_to_player = (player.position - position).angle() + 1.6 # ajuste del sprite
		selectedSprite.rotation = angle_to_player
	else:
		velocity = Vector2.ZERO

func _on_health_component_is_damaged(damage_origin: Vector2) -> void:
	# Calcula la dirección del knockback
	if !isDead:
		var knockback_direction = (position - damage_origin).normalized()
		
		var new_position = position + (knockback_direction * knockback_strength * get_process_delta_time())
		var tween := create_tween()
		# Anima el nodo hacia la nueva posición usando Tween
		tween.tween_property(self, "position", new_position, 0.2)

func _on_health_component_is_dead() -> void:
	isDead = true
