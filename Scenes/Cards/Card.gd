extends Area2D
class_name Card

var number
signal highlight(highlight, number)

func _ready():
	pass # Replace with function body.

func _setSprite(var sprite):
	var spriteNode : Sprite = $Sprite
	spriteNode.texture = sprite


func _on_Card_mouse_entered():
	emit_signal("highlight", true, number)


func _on_Card_mouse_exited():
	emit_signal("highlight", false, number)
