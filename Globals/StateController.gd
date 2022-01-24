extends Node

var player1
var player1Panel
var board
var handGUI
var combatBoard
var gameVariables
var boardTokens = []

var turnManager

var savableClasses = [
	"gameVariables",
	"board",
	"turnManager",
#	"",
#	"",
#	"",
#	"",
#	"",
#	"",
]

func _save():
	var save_dict = {}
	for key in savableClasses:
		save_dict[key] = get(key)._save()
	
	return save_dict

func _load(var save_dict):
	for key in savableClasses:
		get(key)._load(save_dict[key])
