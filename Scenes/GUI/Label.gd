extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	# warning-ignore:return_value_discarded
	get_tree().get_root().get_node("/root/Game/Board").connect("setCurrentMovementCost", self, "setCounter") 

func setCounter(var value):
	text = str(value)
