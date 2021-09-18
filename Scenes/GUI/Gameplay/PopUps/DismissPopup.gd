extends AcceptDialog

func _ready():
	TurnManager.dismissPopup = self
	get_close_button().visible = false
