extends Area2D

@onready var power_up_item : PackedScene = preload("res://escenas/GUI/power_up_item.tscn")
@onready var powerUpPanel : Panel = $"../UI2/PowerUpsPanel"
@export var enemy_scene_1 : PackedScene = preload("res://escenas/enemie.tscn")
@export var spawn_interval : float = 2.0
@export var max_enemies : int = 5
@export var enemies_respawn_cup : int = 10 # limite de enemigos por respaw
@export var max_enemies_cup : int = 250 # limite de enemigos por simultaneos
@export var min_spawn_interval : float = 0.1  # Tiempo mínimo entre spawns
@export var spawn_decrement : float = 0.03  # Cantidad fija para disminuir el spawn interval
@export var enemies_per_spawn : int = 1  # Cantidad de enemigos por spawn
@export var TIME_TO_SHOW_BUFFPANEL : int = 120

var enemy_scenes : Array = []

var _spawn_timer : Timer
var buff_panel_timer : Timer
var _total_time_timer : Timer  # Nuevo temporizador para el tiempo total transcurrido
var _total_time_elapsed : float = 0.0  # Variable para almacenar el tiempo total transcurrido

var _current_enemies : int = 0
var _enemies_killed : int = 0
var random = RandomNumberGenerator.new()

func _ready() -> void:
	buff_panel_timer = Timer.new()
	buff_panel_timer.wait_time = TIME_TO_SHOW_BUFFPANEL 
	buff_panel_timer.connect("timeout", Callable(self, "showBuffPanel"))
	add_child(buff_panel_timer)
	buff_panel_timer.start()

	random.randomize()
	Signals.connect("EnableBuff", _hidePowerUpPanel, 0)

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
	if _enemies_killed % 15 == 0 and max_enemies <= max_enemies_cup:  # Cada 15 enemigos muertos
		max_enemies += 1
		if _enemies_killed % 30 == 0 and enemies_per_spawn < enemies_respawn_cup:  # Cada 30 enemigos muertos
			enemies_per_spawn += 1

func _on_total_time_timeout() -> void:
	# Incrementar el tiempo total transcurrido en segundos
	_total_time_elapsed += 1.0

func showBuffPanel() -> void:
	# Verifica si el tiempo actual es un múltiplo de 60.0 segundos
	addPowerUpButtonToPanel(2)
	
	#var time = int(abs(current_time));
	#print(time)
	#if time > 10 and (time % 120 == 0):  # Usar 60.0 como float y tolerancia también como float

			
func addPowerUpButtonToPanel(numOfButtons) -> void:
	# Lista para almacenar los índices seleccionados
	# Ya que si no, puede repetir buff en la segunda vuelta
	var used_indices : Array = []
	var show_buff_panel : bool = false

	for i in range(numOfButtons):
		# Filtramos los buffs disponibles del array global
		var available_buffs = Signals.BuffArray.filter(func(item):
			return not item["state"] and item["buffKey"] not in used_indices
		)

		if available_buffs.size() <= 0:
			print("No hay buffos disponibles!")
			break

		show_buff_panel = true
		var random_buff_json = available_buffs.pick_random()
		# Añadimos el índice seleccionado a la lista de índices usados
		used_indices.append(random_buff_json.buffKey)

		# Instanciamos el tipo de buff y su label
		var power_up_item_instance = power_up_item.instantiate()
		power_up_item_instance.get_node("PowerUpButton").buffType = random_buff_json.buffKey
		power_up_item_instance.get_node("Label").text = random_buff_json.buffLabel
		powerUpPanel.find_child("HBoxContainer").add_child(power_up_item_instance)
	
	if show_buff_panel:
		_showPowerUpPanel()

func removeBuffButtons() -> void:
	for child in powerUpPanel.find_child("HBoxContainer").get_children():
		child.queue_free()
		
func _hidePowerUpPanel(buff) -> void:
	call_deferred("removeBuffButtons")
	powerUpPanel.visible = false
	get_tree().paused = false
	
func _showPowerUpPanel() ->void:
	get_tree().paused = true
	powerUpPanel.visible = true
