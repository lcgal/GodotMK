extends Node

var game

var loaded_game

var hand_area

var player1
var player_panel
var board
var combat_board
var game_variables
var board_tokens = []

var turn_manager

var savable_classes = [
	"game_variables",
	"board",
	"turn_manager",
	"player1",
	"hand_area",
#	"",
#	"",
#	"",
#	"",
]

func save_game():
	var save_dict = {}
	for key in savable_classes:
		if get(key).has_method("save_game"):
			save_dict[key] = get(key).save_game()
	
	return save_dict

func load_game(var save_dict):
#	FIXME better way to clear previous game data
	board_tokens = []
	for key in savable_classes:
		if get(key).has_method("load_game"):
			get(key).load_game(save_dict[key])

func reset_actions():
	for key in savable_classes:
		if get(key).has_method("reset_actions"):
			get(key).reset_actions()

func quit_game():
	for key in savable_classes:
		if get(key).has_method("quit_game"):
			get(key).quit_game()
