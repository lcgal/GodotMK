extends Label

func _ready():
	# warning-ignore:return_value_discarded
	get_tree().get_root().get_node("/root/Game/Board").connect("set_browntiles_counter", self, "set_counter") 

func set_counter(var value):
	text = str(value)
