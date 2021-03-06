extends Area2D

var key
var feature
var terrain

func _on_Hex_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton && event.button_index == BUTTON_LEFT && event.pressed:
		if (TurnManager.turn_phase == Constants.turn_phase.MOVEMENT):
			if feature == null:
				StateController.board.handle_movement(global_position,terrain)
			else:
				feature.move_into(global_position,terrain)


func _set_Feature(var feature_type, var saved_feature):
	if feature_type in Constants.features:
		var feature_info = Constants.features[feature_type]
		if feature_info != null:
			SceneInitializer.feature(feature_info, saved_feature, self)


func save_game():
	if feature != null:
		return feature.save_game()
