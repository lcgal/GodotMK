extends Area2D

signal exploreTile(location)

func _ready():
	pass # Replace with function body.

func _on_ExplorableTile_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton && event.button_index == BUTTON_LEFT:
		print("teste")
		emit_signal("exploreTile",position)
		queue_free()
