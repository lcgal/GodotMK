extends Control

var value = 0

func set_texture(var texture):
	get_node("Crystal").texture = texture

func _add_value(qtd):
	value += qtd
	$Label.text = str(value)
