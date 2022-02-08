extends TextureRect

func _connect(var player):
	player.connect("update_deck_count", self,  "set_counter")

func set_counter(var value):
	$HandCount.text = str(value)
	
