extends Button

@export var buffType : BuffEnum

enum BuffEnum {
	ESCUDO,
	LASER,
	NAVE,
	ATTACK_SPEED,
	ATTACK_SPEED_ALLY
}

# Array que mapea los valores del enum a strings
var buffTypeStrings = ["escudo", "laser", "nave", "attack_speed", "attack_speed_ally"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.connect("pressed", self._on_button_pressed)

func _on_button_pressed() -> void:
	Signals.emit_signal("EnableBuff", buffTypeStrings[buffType])
