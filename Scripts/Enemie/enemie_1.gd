extends CharacterBody2D

@export var SPEED: float = 20.0

@onready var player : CharacterBody2D = $"../Nave"
@onready var sprite : Sprite2D = $Sprite2D

func _physics_process(delta: float) -> void:
	move_and_slide()
	move_to_player()
	
func move_to_player():
	var distance_to_player = position.distance_to(player.position)
	
	if distance_to_player > 30.0:
		var direction = (player.position - position).normalized()
		velocity = direction * SPEED
		position += velocity * get_process_delta_time()
		
		# Ajustar el ángulo del sprite para que apunte hacia el jugador
		var angle_to_player = (player.position - position).angle() + 1.6 # ajuste del sprite
		sprite.rotation = angle_to_player
	else:
		velocity = Vector2.ZERO


func _on_health_component_is_damaged(damage_origin: Vector2) -> void:
	# Calcula la dirección del knockback
	var knockback_direction = (position - damage_origin).normalized()
	# Calcula la nueva posición
	var knockback_strength =  1000.0
	
	var new_position = position + (knockback_direction * knockback_strength * get_process_delta_time())
	var tween := create_tween()
	# Anima el nodo hacia la nueva posición usando Tween
	tween.tween_property(self, "position", new_position, 0.2)
