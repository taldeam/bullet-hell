extends CanvasLayer

@onready var enemies_dead_label : Label = $Label
var total_enemies_dead = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enemies_dead_label.text = str(total_enemies_dead)
	Signals.connect("EnemieDead", enemieDead, 0)
	
func enemieDead() -> void:
	total_enemies_dead += 1
	enemies_dead_label.text = str(total_enemies_dead)
	pass # Replace with function body.


func _on_touch_screen_button_pressed() -> void:
	var current_scene = get_tree().current_scene
	get_tree().reload_current_scene()
