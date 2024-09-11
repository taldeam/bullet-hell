extends Control

#@onready var gameScene : PackedScene = preload("res://escenas/mundo.tscn")
#
#func _ready() -> void:
	#gameScene.instantiate()
	
func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://escenas/mundo.tscn")
