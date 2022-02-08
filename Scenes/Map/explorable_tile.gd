extends Area2D
class_name ExplorableTile

signal exploreTile(location,key,adjacent_tiles)

signal activate()

var adjacency = 0

var adjacent_tiles

var active = false

var key

func save_game():
	var save_dict = {}
	save_dict["key"] = key
	save_dict["active"] = active
	save_dict["adjacent_tiles"] = adjacent_tiles
	save_dict["adjacency"] = adjacency

func load_game(var save_dict):
	key = save_dict["key"]
	key = save_dict["active"]
	key = save_dict["adjacent_tiles"]
	key = save_dict["adjacency"]

func _on_ExplorableTile_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton && event.button_index == BUTTON_LEFT && event.pressed && active:
		explore()

func explore():
	emit_signal("exploreTile",position,key,adjacent_tiles)

func activate():
	active = true
	emit_signal("activate")

