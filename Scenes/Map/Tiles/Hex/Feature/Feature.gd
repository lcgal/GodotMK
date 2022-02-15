extends Node2D

var type
var hex_token
var feature_info

func _setFeature(var info, var saved_info):
	feature_info = info
	if feature_info != null && feature_info["Token"] != null:
		hex_token = SceneInitializer.feature_token(feature_info["Token"], saved_info, self)
	

func move_into(var global_position, var terrain):
	if feature_info != null:
		if feature_info["AutoCombat"]:
			if(StateController.board.handle_movement(global_position, terrain, true)):
				start_combat(true)
	else:
		StateController.board.handle_movement(global_position, terrain)


func start_combat(var move_back):
	if hex_token != null:
		hex_token.active = false
		remove_child(hex_token)
		TurnManager.start_combat(hex_token, move_back, self)


func failed_combat(var tokens):
	for token in tokens:
		add_child(token)


func save_game():
	var save_dict = {}
	if hex_token != null:
		save_dict = hex_token.save_game()
		return save_dict


func load_game(var saved_feature_info):
	if hex_token != null:
		hex_token.load_game(saved_feature_info)
