extends RigidBody2D

@export var SPEED: float = 20.0
@onready var player: CharacterBody2D = $"../Nave"
@onready var sprite: Sprite2D = $Sprite2D
@export var knockback_strength: float = 1000.0
var isDead = false

func _physics_process(delta: float) -> void:
	if !isDead:
		move_to_player()

func move_to_player() -> void:
	var distance_to_player = position.distance_to(player.position)
	
	if distance_to_player > 30.0:
		var direction = (player.position - position).normalized()
		linear_velocity = direction * SPEED  # Usar linear_velocity para RigidBody2D

		# Ajustar el ángulo del sprite para que apunte hacia el jugador
		var angle_to_player = (player.position - position).angle() + 1.6  # ajuste del sprite
		sprite.rotation = angle_to_player
	else:
		linear_velocity = Vector2.ZERO  # Detener el movimiento cuando esté cerca del jugador

func _on_health_component_is_damaged(damage_origin: Vector2) -> void:
	if !isDead:
		var knockback_direction = (position - damage_origin).normalized()
		# Aplicar un impulso (knockback) al RigidBody2D
		apply_impulse(Vector2.ZERO, knockback_direction * knockback_strength)

func _on_health_component_is_dead() -> void:
	isDead = true
	linear_velocity = Vector2.ZERO  # Detener el movimiento cuando el enemigo muere
