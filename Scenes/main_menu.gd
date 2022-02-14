extends Control

func _on_NewGameBtn_pressed():
	# warning-ignore:return_value_discarded
	StateController.loaded_game = null
	get_tree().change_scene("res://Scenes/game.tscn")


func _on_QuitBtb_pressed():
	get_tree().quit()


func _on_LoadBtn_pressed():
	$LoadMenu.visible = true
