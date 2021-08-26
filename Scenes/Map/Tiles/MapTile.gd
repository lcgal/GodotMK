extends Area2D
class_name MapTile

func _ready():
	pass

func setTile(var spritePath):
	var sprite = load(spritePath)
	var spriteNode : Sprite = get_node("Sprite")
	spriteNode.texture = sprite
