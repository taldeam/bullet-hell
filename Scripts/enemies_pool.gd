extends Node

# El "Scene" que instanciamos (el objeto a pool).
@export var enemie_scene: PackedScene
@export var pool_size: int = 200 # Tamaño inicial del pool

# La lista que contendrá los objetos reutilizables.
var available_enemies: Array[Node] = []

# Precarga objetos en el pool al inicio
func _ready() -> void:
	for i in range(pool_size):
		var new_object = enemie_scene.instantiate()
		available_enemies.append(new_object)
		#add_child(new_object)  # Añadirlos a la escena, pero ocultos body.
	
# Función para obtener un objeto del pool
func get_object() -> Node:
	if available_enemies.is_empty():
		var new_object = enemie_scene.instantiate()
		return new_object
	else:
		return available_enemies.pop_back()

func return_object(obj: Node) -> void:
	get_tree().current_scene.remove_child(obj)
	#obj.get_parent().remove_child(obj)
	obj.health_collision.disabled = false
	obj.hit_collision.disabled = false
	available_enemies.append(obj)
