extends Control

signal reset()

func _ready():
	pass

func _on_Buttons_reset():
	emit_signal("reset")
