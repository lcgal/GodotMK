extends Control

var file

func set_item(var item):
	$Button.text = item
	file = item


func _on_Button_pressed():
	StateController.loadedGame = file
	var game = get_tree().get_root().get_node("/root/Game")
	if is_instance_valid(game):
		game._close()
	get_tree().change_scene("res://Scenes/game.tscn")
