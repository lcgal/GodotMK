extends TextureRect

func _connect(var player):
	player.connect("updateDeckCount", self,  "_setCounter")

func _setCounter(var value):
	$HandCount.text = str(value)
	
