extends PopupMenu

func _ready():
	TurnManager.playCardPopup = self
	rect_min_size = Vector2(200,100)
	self.clear()
