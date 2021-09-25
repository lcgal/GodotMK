extends Area2D
class_name MapTile

var n = Vector2(105,180)
var k = Vector2(-105,180)
var hexes

signal movement(position,key)

func setTile(var sprite):
	var spriteNode : Sprite = get_node("Sprite")
	spriteNode.texture = sprite

func _setHexes(var hexesInfo):
	hexes = hexesInfo
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
	var terrain = hexes[key]["Terrain"]
	emit_signal("movement", pos, terrain)
