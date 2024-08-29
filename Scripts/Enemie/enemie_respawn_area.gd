extends Area2D

@export var enemy_scene_1 : PackedScene = preload("res://escenas/enemie.tscn")
#@export var enemy_scene_2 : PackedScene = preload("res://escenas/enemie_2.tscn")
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
	#enemy_scenes.append(enemy_scene_2)

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
	# var enemy_instance = selected_scene.instantiate()
	var enemy_instance = enemy_scene_1.instantiate()

	var rand_point = NavigationServer2D.map_get_random_point($"../NavigationRegion2D".get_navigation_map(), 1, false)
	var global_position = $"../NavigationRegion2D".global_position
	var transformed_point = rand_point + global_position

	print(rand_point)

	# Convierte la posición local a global
	enemy_instance.position = rand_point
	# Agregarla al árbol de nodos
	get_parent().add_child(enemy_instance)
	# Incrementar el conteo de enemigos
	_current_enemies += 1
	# Conectar una señal para saber cuando la nave enemiga es destruida y disminuir el conteo
	enemy_instance.connect("tree_exited", Callable(self, "_on_enemy_exited"))

func _on_enemy_exited() -> void:
	_current_enemies -= 1
