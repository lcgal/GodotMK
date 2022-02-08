extends Control


func _on_OptionsBtn_pressed():
	$OptionsMenu.visible = true


func _on_OptionsMenu_open_load_menu():
	$LoadMenu.visible = true
