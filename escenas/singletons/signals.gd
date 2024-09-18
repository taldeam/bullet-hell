extends Node

signal EnemieDead
signal EnableBuff

var nave: CharacterBody2D

var player_position
var enemies_in_group : Array = []

# cada vez que añada un buff aqui, hacerlo en power_up_item
var BuffArray : Array = [
	{
	"state": false,
	"buffKey": 0,
	"buffName": "escudo",
	"buffLabel": "Añade un escudo que resiste hasta 5 impatos."
	},
	{
	"state": false,
	"buffKey": 1,
	"buffName": "laser",
	"buffLabel": "Añade un laser automático cada 15 segundos."
	},
	{
	"state": false,
	"buffKey": 2,
	"buffName": "nave",
	"buffLabel": "Añade una nave aliada en tu posición."
	},
	{
	"state": false,
	"buffKey": 3,
	"buffName": "attack_speed",
	"buffLabel": "Aumenta tu velocidad de ataque un 10%."
	},
	{
	"state": true,
	"buffKey": 4,
	"buffName": "attack_speed_ally",
	"buffLabel": "Aumenta la velocidad de ataque de las naves aliadas un 10%."
	}
]

func _ready() -> void:
	nave = get_tree().root.get_node("mundo/Nave")
	player_position = nave.position
	enemies_in_group = get_tree().get_nodes_in_group("enemies")
	
func _process(delta: float) -> void:
	player_position = nave.position
	#enemies_in_group = get_tree().get_nodes_in_group("enemies")
