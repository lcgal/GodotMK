extends Control

func _on_NewGameBtn_pressed():
	# warning-ignore:return_value_discarded
	StateController.loadedGame = null
	get_tree().change_scene("res://Scenes/game.tscn")


func _on_QuitBtb_pressed():
	get_tree().quit()
