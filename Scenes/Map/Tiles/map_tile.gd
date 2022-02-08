extends Area2D
class_name MapTile

var n = Vector2(105,180)
var k = Vector2(-105,180)
var tile_info


func save_game():
	var save_dict = {}
	save_dict["tile_info"] = tile_info
	save_dict["position"] = global_position
	var features_dict = {}
	for key in tile_info["Hexes"]:
		var hex = get_node(key)
		var hex_save_info = hex.save_game()
		if hex_save_info != null:
			features_dict[key] = hex.save_game()
	save_dict["features_info"] = features_dict

	return save_dict
	
func load_game(var features_info):
	for key in features_info:
		pass

func set_tile(var tile, var saved_feature_info = null):
	tile_info = tile
	var spriteNode : Sprite = get_node("Sprite")
	spriteNode.texture = Assets.map_tile(tile["Sprite"])
	_set_hexes(tile["Hexes"])
	if saved_feature_info != null:
		for hex in saved_feature_info:
			get_node(hex).load_game(saved_feature_info[hex])

func _set_hexes(var hexes_info):
	var hexes = hexes_info
	for key in Constants.hexes:
		_hexes(key,Constants.hexes[key]["x"],Constants.hexes[key]["y"],hexes[key]["Feature"])

func _hexes(var key, var x, var y, var feature):
	var hex_scene_instance = load("res://Scenes/Map/Tiles/Hex/hex.tscn").instance()
	add_child(hex_scene_instance)
	hex_scene_instance.set_name(key)
	hex_scene_instance.key = key
	hex_scene_instance.position = x*n + y*k
	hex_scene_instance.terrain = tile_info["Hexes"][key]["Terrain"]
	hex_scene_instance._set_Feature(feature)
