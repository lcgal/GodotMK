extends Area2D

var key
var feature
var terrain

func _on_Hex_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton && event.button_index == BUTTON_LEFT && event.pressed:
		if feature == null:
			StateController.board.handle_movement(global_position,terrain)
		else:
			feature._moveInto(global_position,terrain)


func _set_Feature(var feature_type):
	if feature_type in Constants.features:
		var feature_info = Constants.features[feature_type]
		if feature_info != null:
			SceneInitializer.feature(feature_info, self)

func save_game():
	if feature != null:
		return feature.save_game()
	
func load_game(var saved_feature_info):
	feature.load_game(saved_feature_info)
