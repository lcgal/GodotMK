extends Node

var loadedGame

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
	"player1",
#	"",
#	"",
#	"",
#	"",
#	"",
]

func _save():
	var save_dict = {}
	for key in savableClasses:
		if get(key).has_method("_save"):
			save_dict[key] = get(key)._save()
	
	return save_dict

func _load(var save_dict):
	for key in savableClasses:
		if get(key).has_method("_load"):
			get(key)._load(save_dict[key])

func _reset():
	for key in savableClasses:
		if get(key).has_method("_reset"):
			get(key)._reset()

func _quit():
	for key in savableClasses:
		if get(key).has_method("_quit"):
			get(key)._quit()
