extends AcceptDialog

func _ready():
	TurnManager.dismiss_popup = self
	get_close_button().visible = false
