extends Node2D

var type
var tokens = []
var hex_token
var feature_info

func _setFeature(var info):
	feature_info = info
	if feature_info != null && feature_info["Token"] != null:
		SceneInitializer.token(feature_info, self)

func _moveInto(var global_position, var terrain):
	if feature_info != null:
		if feature_info["AutoCombat"]:
			if(StateController.board.handle_movement(global_position, terrain, true)):
				start_combat()
	else:
		StateController.board.handle_movement(global_position, terrain)

func start_combat():
	if hex_token != null:
		remove_child(hex_token)
		TurnManager.start_combat(hex_token)

func save_game():
	var save_dict = {}
	if hex_token != null:
		save_dict = hex_token.save_game()
		return save_dict

func load_game(var saved_feature_info):
	if hex_token != null:
		hex_token.load_game(saved_feature_info)
