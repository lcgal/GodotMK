extends Label

func _ready():
	get_tree().get_root().get_node("/root/Game/Board").connect("setBrownTileCounter", self, "_setCounter") 

func _setCounter(var value):
	text = str(value)
