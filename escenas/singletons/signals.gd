extends Node

signal EnemieDead
signal EnableBuff

var BuffArray : Array = [
	{
	"state": false,
	"buffKey": 0,
	"buffName": "escudo",
	"buffLabel": "Añade un escudo"
	},
	{
	"state": false,
	"buffKey": 1,
	"buffName": "laser",
	"buffLabel": "Añade un laser"
	},
	{
	"state": false,
	"buffKey": 2,
	"buffName": "nave",
	"buffLabel": "Añade una nave aliada"
	}
]
