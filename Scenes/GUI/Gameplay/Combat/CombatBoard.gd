extends Control


func _ready():
	GameVariables.combatBoard = self
	var viewportWidth = get_viewport().size.x
	var viewportHeight = get_viewport().size.y
	var scale = viewportWidth / $Sprite.texture.get_size().x
	$Sprite.set_scale(Vector2(scale, scale))
	
func _startCombat(var tokens):
	visible = true
	for token in tokens:
		var combatlane = load("res://Scenes/GUI/Gameplay/Combat/CombatLane/CombatLane.tscn").instance()
		combatlane.add_to_group("combatLane")
		add_child(combatlane)
		combatlane.position = $Sprite.texture.get_size()/3
		combatlane._addToken(token)

func _endCombatPhase(var phase):
	var teste = get_tree().get_nodes_in_group("combatLane")
	get_tree().call_group("combatLane", "_endCombatPhase", phase)

