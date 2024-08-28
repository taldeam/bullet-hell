extends Area2D

@export var enemy_scene_1 : PackedScene = preload("res://escenas/enemie_1.tscn")
@export var enemy_scene_2 : PackedScene = preload("res://escenas/enemie_2.tscn")
@export var spawn_interval : float = 2.0
@export var max_enemies : int = 5
var enemy_scenes : Array = []

var _spawn_timer : Timer
var _current_enemies : int = 0

func _ready() -> void:
	# Inicializar el temporizador para instanciar naves enemigas
	_spawn_timer = Timer.new()
	_spawn_timer.wait_time = spawn_interval
	_spawn_timer.connect("timeout", Callable(self, "_on_spawn_timeout"))
	add_child(_spawn_timer)
	_spawn_timer.start()
	
	enemy_scenes.append(enemy_scene_1)
	enemy_scenes.append(enemy_scene_2)

func _process(delta: float) -> void:
	# Opcional: Puedes agregar lógica adicional si es necesario en cada frame
	pass

func _on_spawn_timeout() -> void:
	if _current_enemies < max_enemies:
		_spawn_enemy()

func _spawn_enemy() -> void:
	# Instanciar la escena de la nave enemiga	
	var random_index = randi() % enemy_scenes.size()
	var selected_scene = enemy_scenes[random_index]
	var enemy_instance = selected_scene.instantiate()

	# Obtener la forma de colisión del Area2D para determinar el área de spawn
	var collision_shape = $CollisionShape2D.shape as RectangleShape2D
	var area_size = collision_shape.extents * 2  # El tamaño total del área de colisión

	# Calcular una posición aleatoria dentro del área
	var random_position = Vector2(
		randf_range(-area_size.x / 2, area_size.x / 2),
		randf_range(-area_size.y / 2, area_size.y / 2)
	)
	# Posicionar la nave enemiga en la posición aleatoria calculada
	enemy_instance.position = global_position + random_position
	# Agregarla al árbol de nodos
	get_parent().add_child(enemy_instance)
	# Incrementar el conteo de enemigos
	_current_enemies += 1
	# Conectar una señal para saber cuando la nave enemiga es destruida y disminuir el conteo
	enemy_instance.connect("tree_exited", Callable(self, "_on_enemy_exited"))

func _on_enemy_exited() -> void:
	print('muerte')
	_current_enemies -= 1
