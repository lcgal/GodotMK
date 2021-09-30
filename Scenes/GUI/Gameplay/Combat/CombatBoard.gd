extends Control


func _ready():
	GameVariables.combatBoard = self
	
func _startCombat(var tokens):
	visible = true
	for token in tokens:
		var combatlane = load("res://Scenes/GUI/Gameplay/Combat/CombatLane/CombatLane.tscn").instance()
		add_child(combatlane)
		combatlane.position = $Sprite.texture.get_size()/2
		combatlane._addToken(token)
		
