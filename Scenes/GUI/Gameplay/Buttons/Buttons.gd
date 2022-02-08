extends HBoxContainer

func _ready():
	pass # Replace with function body.

func _on_Reset3_button_up():
	TurnManager.confirm()


func _on_Reset_button_up():
	StateController.reset_actions()
