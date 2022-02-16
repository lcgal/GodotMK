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
	"player1",
	"hand_area",
	"combat_board",
#	"",
#	"",
	"turn_manager",
]


func save_game():
	var save_dict = {}
	for key in savable_classes:
		if get(key).has_method("save_game"):
			save_dict[key] = get(key).save_game()
	
	return save_dict


func load_game(var save_dict):
	# FIXME better way to clear previous game data
	
	for key in savable_classes:
		if get(key).has_method("load_game"):
			get(key).load_game(save_dict[key])


func reset_actions():
	# warning-ignore:return_value_discarded
	StateController.game._close()
	get_tree().change_scene("res://Scenes/game.tscn")
	#for key in savable_classes:
	#	if get(key).has_method("reset_actions"):
	#		get(key).reset_actions()


func new_game():
	board_tokens = []
	for key in savable_classes:
		if is_instance_valid(get(key)) and get(key).has_method("new_game"):
			get(key).new_game()


func quit_game():
	for key in savable_classes:
		if get(key).has_method("quit_game"):
			get(key).quit_game()
