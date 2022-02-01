extends Control


func _on_OptionsBtn_pressed():
	$OptionsMenu.visible = true


func _on_OptionsMenu_openLoadMenu():
	$LoadMenu.visible = true
