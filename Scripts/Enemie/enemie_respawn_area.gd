extends Area2D

@onready var powerUpPanel : Panel = $"../UI2/PowerUpsPanel"
@export var enemy_scene_1 : PackedScene = preload("res://escenas/enemie.tscn")
@export var spawn_interval : float = 2.0
@export var max_enemies : int = 5
@export var min_spawn_interval : float = 0.1  # Tiempo mínimo entre spawns
@export var spawn_decrement : float = 0.05  # Cantidad fija para disminuir el spawn interval
@export var enemies_per_spawn : int = 1  # Cantidad de enemigos por spawn
var enemy_scenes : Array = []

var _spawn_timer : Timer
var _total_time_timer : Timer  # Nuevo temporizador para el tiempo total transcurrido
var _total_time_elapsed : float = 0.0  # Variable para almacenar el tiempo total transcurrido

var _current_enemies : int = 0
var _enemies_killed : int = 0
var random = RandomNumberGenerator.new()

func _ready() -> void:
	random.randomize()

	# Configuración del temporizador de spawn
	_spawn_timer = Timer.new()
	_spawn_timer.wait_time = spawn_interval
	_spawn_timer.connect("timeout", Callable(self, "_on_spawn_timeout"))
	add_child(_spawn_timer)
	_spawn_timer.start()
	
	# Configuración del temporizador de tiempo total
	_total_time_timer = Timer.new()
	_total_time_timer.wait_time = 1.0  # Actualiza cada segundo
	_total_time_timer.connect("timeout", Callable(self, "_on_total_time_timeout"))
	add_child(_total_time_timer)
	_total_time_timer.start()
	
	enemy_scenes.append(enemy_scene_1)

func _on_spawn_timeout() -> void:
	if _current_enemies < max_enemies:
		for i in range(enemies_per_spawn):
			if _current_enemies < max_enemies:  # Asegurarse de no superar el límite
				_spawn_enemy()

func _spawn_enemy() -> void:
	$"../UI2/Enemies_in_game/Label3".text = str(_current_enemies)
	
	var random_index = randi() % enemy_scenes.size()
	var selected_scene = enemy_scenes[random_index]
	var enemy_instance = selected_scene.instantiate()

	var collision_shape = $CollisionShape2D.shape as RectangleShape2D
	var area_size = collision_shape.extents * 2

	var random_position_top = Vector2(random.randi_range(-687, 895), -240)
	var random_position_bottom = Vector2(random.randi_range(-687, 895), 464)
	var random_position_right = Vector2(900, random.randi_range(-240, 466))
	var random_position_left = Vector2(-680, random.randi_range(-243, 453))

	var positions = [
		random_position_top,
		random_position_bottom,
		random_position_right,
		random_position_left
	]

	var selected_position = positions[random.randi_range(0, positions.size() - 1)]
	
	enemy_instance.global_position = selected_position

	get_tree().current_scene.add_child(enemy_instance)

	_current_enemies += 1
	enemy_instance.connect("tree_exited", Callable(self, "_on_enemy_exited"))

func _on_enemy_exited() -> void:
	_current_enemies -= 1
	_enemies_killed += 1
	
	# Reducir el intervalo de spawn de manera lineal
	if spawn_interval > min_spawn_interval:
		spawn_interval = max(spawn_interval - spawn_decrement, min_spawn_interval)
		_spawn_timer.wait_time = spawn_interval
	
	# Incrementar el número máximo de enemigos y la cantidad de enemigos por spawn
	if _enemies_killed % 10 == 0:  # Cada 10 enemigos muertos
		max_enemies += 1
		if _enemies_killed % 20 == 0:  # Cada 20 enemigos muertos
			enemies_per_spawn += 1

func _on_total_time_timeout() -> void:
	# Incrementar el tiempo total transcurrido en segundos
	_total_time_elapsed += 1.0
	# Puedes añadir aquí lógica para lo que quieras hacer con el tiempo transcurrido
	showBuffPanel(_total_time_elapsed)

func showBuffPanel(current_time) -> void:
	match current_time:
		15.0, 35.0, 65.0, 105.0, 155.0, 220.0, 340.0:  # Añade más casos si es necesario
			get_tree().paused = true
			powerUpPanel.visible = true
			_spawn_timer.stop()  # Detén el temporizador mientras el juego está en pausa
			_total_time_timer.stop()  # Detén también el temporizador del tiempo total
		_:
			pass


#! Tengo que hacer algo con esto, estandarizarlo
func _on_power_up_button_pressed() -> void:
	powerUpPanel.visible = false
	get_tree().paused = false
	_spawn_timer.start()
	_total_time_timer.start()  # Reanuda el temporizador del tiempo total


func _on_power_up_button_nave_pressed() -> void:
	powerUpPanel.visible = false
	get_tree().paused = false
	_spawn_timer.start()
	_total_time_timer.start()  # Reanuda el temporizador del tiempo total
