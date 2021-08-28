extends Area2D
class_name MapTile

var n = Vector2(105,180)
var k = Vector2(-105,180)

func _ready():
	hexes("W",1,-1)
	hexes("E",-1,1)
	hexes("SW",0,1)
	hexes("NE",0,-1)
	hexes("SE",-1,0)
	hexes("NW",1,0)
	hexes("C",0,0)

func hexes(var key, var x, var y):
	var hexScene = load("res://Scenes/Map/Tiles/Hex/Hex.tscn")
	var hexSceneInstance = hexScene.instance()
	hexSceneInstance.set_name(key)
	hexSceneInstance.position = x*n + y*k
	add_child(hexSceneInstance)
	hexSceneInstance.connect("movement",self,"handleMovement")

func setTile(var spritePath):
	var sprite = load(spritePath)
	var spriteNode : Sprite = get_node("Sprite")
	spriteNode.texture = sprite

func handleMovement(var position):
	print(position)
