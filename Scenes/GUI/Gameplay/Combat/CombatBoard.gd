extends Control


func _ready():
	GameVariables.combatBoard = self
	
func _startCombat():
	visible = true
