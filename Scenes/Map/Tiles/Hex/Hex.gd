extends Area2D

var key
signal movement(pos,key)

func _ready():
	pass # Replace with function body.

func _on_Hex_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton && event.button_index == BUTTON_LEFT && event.pressed:
		emit_signal("movement",global_position,key)
