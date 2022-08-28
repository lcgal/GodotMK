extends Node2D

var type
var hex_token
var feature_info
var in_combat = false

func set_feature(var info, var saved_info):
	feature_info = info
	if feature_info != null && feature_info["Token"] != null:
		
		var saved_token_info
		if saved_info != null:
			_load_game(saved_info)
			if "token" in saved_info:
				saved_token_info = saved_info["token"]
		
		hex_token = SceneInitializer.feature_token(feature_info["Token"], saved_token_info, self)
	

func move_into(var global_position, var terrain):
	if feature_info != null:
		if feature_info["AutoCombat"]:
			if(StateController.board.handle_movement(global_position, terrain, true)):
				start_combat(true)
	else:
		StateController.board.handle_movement(global_position, terrain)


func start_combat(var move_back):
	in_combat = true
	if hex_token != null:
		hex_token.active = false
		remove_child(hex_token)
		TurnManager.start_combat(hex_token, move_back, self)


func end_combat(var victorious, var original_token, var tokens):
	in_combat = false
	if !victorious:
		hex_token = original_token
		hex_token.active = true
		for token in tokens:
			add_child(token)


func save_game():
	var save_dict = {}
	save_dict["in_combat"] = in_combat
	if hex_token != null:
		var hex_token_save_dict = hex_token.save_game()
		save_dict["token"] = hex_token_save_dict
	return save_dict


func _load_game(var saved_feature_info):
	in_combat = saved_feature_info["in_combat"]
	if in_combat:
		StateController.combat_board.origin_feature = self
#	if hex_token != null:
#		hex_token.load_game(saved_feature_info["token"])
