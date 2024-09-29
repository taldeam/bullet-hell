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
		"buffLabel": "Adds a shield that withstands up to 5 impacts"
	},
	{
		"state": false,
		"buffKey": 1,
		"buffName": "laser",
		"buffLabel": "Adds an automatic laser every 15 seconds"
	},
	{
		"state": false,
		"buffKey": 2,
		"buffName": "nave",
		"buffLabel": "Adds an allied ship at your position"
	},
	{
		"state": false,
		"buffKey": 3,
		"buffName": "attack_speed",
		"buffLabel": "Increases your attack speed by 10%"
	},
	{
		"state": true,
		"buffKey": 4,
		"buffName": "attack_speed_ally",
		"buffLabel": "Increases the attack speed of allied ships by 10%"
	},
	{
		"state": false,
		"buffKey": 5,
		"buffName": "attack_damage",
		"buffLabel": "Increases your attack damage by 1"
	},
	{
		"state": false,
		"buffKey": 6,
		"buffName": "movement_speed",
		"buffLabel": "Increases your movement speed by 10%"
	}
]

func _ready() -> void:
	nave = get_tree().root.get_node("mundo/Nave")
	player_position = nave.position
	#enemies_in_group = get_tree().get_nodes_in_group("enemies")
	
func _process(_delta: float) -> void:
	if !nave:
		nave = get_tree().root.get_node("mundo/Nave")
	
	player_position = nave.position
	#enemies_in_group = get_tree().get_nodes_in_group("enemies")
