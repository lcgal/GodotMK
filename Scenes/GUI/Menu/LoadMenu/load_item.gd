extends Control

var file

func set_item(var item):
	$Button.text = item
	file = item


func _on_Button_pressed():
	# warning-ignore:return_value_discarded
	StateController.loaded_game = file
	if is_instance_valid(StateController.game):
		StateController.game._close()
	get_tree().change_scene("res://Scenes/game.tscn")
