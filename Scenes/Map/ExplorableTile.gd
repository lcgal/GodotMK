extends Area2D
class_name ExplorableTile

signal exploreTile(location,key,adjacentTiles)

signal activate()

var adjacency = 0

var adjacentTiles

var active = false

var key

func _save():
	var save_dict = {}
	save_dict["key"] = key
	save_dict["active"] = active
	save_dict["adjacentTiles"] = adjacentTiles
	save_dict["adjacency"] = adjacency

func _load(var save_dict):
	key = save_dict["key"]
	key = save_dict["active"]
	key = save_dict["adjacentTiles"]
	key = save_dict["adjacency"]

func _on_ExplorableTile_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton && event.button_index == BUTTON_LEFT && event.pressed && active:
		explore()

func explore():
	emit_signal("exploreTile",position,key,adjacentTiles)

func activate():
	active = true
	emit_signal("activate")

