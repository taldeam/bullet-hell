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
