extends Area2D
class_name ExplorableTile

signal exploreTile(location,key,adjacentTiles)

signal activate()

var adjacency = 0

var adjacentTiles

var active = false

var key

func _ready():
	pass # Replace with function body.

func _on_ExplorableTile_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton && event.button_index == BUTTON_LEFT && event.pressed && active:
		explore()

func explore():
	emit_signal("exploreTile",position,key,adjacentTiles)

func activate():
	active = true
	emit_signal("activate")

