extends Area2D
class_name MapTile

var n = Vector2(105,180)
var k = Vector2(-105,180)
var tile_info


func _save():
	var save_dict = {}
	save_dict["tile_info"] = tile_info
	save_dict["position"] = global_position
	var features_dict = {}
	for key in tile_info["Hexes"]:
		var hex = get_node(key)
		var hex_save_info = hex._save()
		if hex_save_info != null:
			features_dict[key] = hex._save()
	save_dict["features_info"] = features_dict

	return save_dict
	
func _load(var features_info):
	for key in features_info:
		pass

func setTile(var tile, var savedFeatureInfo = null):
	tile_info = tile
	var spriteNode : Sprite = get_node("Sprite")
	spriteNode.texture = Assets._mapTile(tile["Sprite"])
	_setHexes(tile["Hexes"])
	if savedFeatureInfo != null:
		for hex in savedFeatureInfo:
			get_node(hex)._load(savedFeatureInfo[hex])

func _setHexes(var hexesInfo):
	var hexes = hexesInfo
	for key in Constants.hexes:
		_hexes(key,Constants.hexes[key]["x"],Constants.hexes[key]["y"],hexes[key]["Feature"])

func _hexes(var key, var x, var y, var feature):
	var hexScene = load("res://Scenes/Map/Tiles/Hex/hex.tscn")
	var hexSceneInstance = hexScene.instance()
	add_child(hexSceneInstance)
	hexSceneInstance.set_name(key)
	hexSceneInstance.key = key
	hexSceneInstance.position = x*n + y*k
	hexSceneInstance.terrain = tile_info["Hexes"][key]["Terrain"]
	hexSceneInstance._set_Feature(feature)
