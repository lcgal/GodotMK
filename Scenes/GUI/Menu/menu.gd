extends Control

signal open_load_menu()

func _on_Resume_pressed():
	visible = false


func _on_Main_Menu_pressed():
	# warning-ignore:return_value_discarded
	StateController.reset_actions()
	Configs.save_game()
	var game = get_tree().get_root().get_node("/root/Game")
	game._close()
	
	get_tree().change_scene("res://Scenes/main_menu.tscn")
	


func _on_LoadBtn_pressed():
	emit_signal("open_load_menu")
