extends HBoxContainer

signal reset()

func _ready():
	pass # Replace with function body.

func _on_Reset_pressed():
	emit_signal("reset")
