extends PopupMenu

func _ready():
	TurnManager.options_popup = self
	rect_min_size = Vector2(200,100)
	self.clear()
