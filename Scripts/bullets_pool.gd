extends Node

# El "Scene" que instanciamos (el objeto a pool).
@export var bullet_scene: PackedScene
@export var pool_size: int = 200 # Tamaño inicial del pool

# La lista que contendrá los objetos reutilizables.
var available_bullets: Array[Node] = []

# Precarga objetos en el pool al inicio
func _ready() -> void:
	for i in range(pool_size):
		var new_object = bullet_scene.instantiate()
		new_object.bind_tween()
		available_bullets.append(new_object)
		#add_child(new_object)  # Añadirlos a la escena, pero ocultos body.
	
# Función para obtener un objeto del pool
func get_object() -> Node:
	if available_bullets.is_empty():
		var new_object = bullet_scene.instantiate()
		new_object.bind_tween()
		return new_object
	else:
		return available_bullets.pop_back()

func return_object(obj: Node) -> void:
	obj.get_parent().remove_child(obj)
	#if obj.get_parent():
	available_bullets.append(obj)
