extends ConfirmationDialog


func _ready():
	TurnManager.confirmation_popup = self
