extends Area2D
class_name MapTile

var n = Vector2(105,180)
var k = Vector2(-105,180)
var tile_info

signal movement(position,key)

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

func setTile(var tile, var savedInfo = null):
	tile_info = tile
	var spriteNode : Sprite = get_node("Sprite")
	spriteNode.texture = Assets._mapTile(tile["Sprite"])
	_setHexes(tile["Hexes"])

func _setHexes(var hexesInfo):
	var hexes = hexesInfo
	_hexes("E",1,-1,hexes["E"]["Feature"])
	_hexes("W",-1,1,hexes["W"]["Feature"])
	_hexes("SW",0,1,hexes["SW"]["Feature"])
	_hexes("NE",0,-1,hexes["NE"]["Feature"])
	_hexes("NW",-1,0,hexes["NW"]["Feature"])
	_hexes("SE",1,0,hexes["SE"]["Feature"])
	_hexes("C",0,0,hexes["C"]["Feature"])

func _hexes(var key, var x, var y, var feature):
	var hexScene = load("res://Scenes/Map/Tiles/Hex/Hex.tscn")
	var hexSceneInstance = hexScene.instance()
	add_child(hexSceneInstance)
	hexSceneInstance.set_name(key)
	hexSceneInstance.key = key
	hexSceneInstance.position = x*n + y*k
	hexSceneInstance._set_Feature(feature)
	hexSceneInstance.connect("movement",self,"handleMovement")

func handleMovement(var pos, var key):
	var terrain = tile_info["Hexes"][key]["Terrain"]
	emit_signal("movement", pos, terrain)
