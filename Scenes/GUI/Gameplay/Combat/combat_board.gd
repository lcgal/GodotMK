extends Control

func _ready():
	StateController.combatBoard = self
	var viewportWidth = get_viewport().size.x
	#var viewportHeight = get_viewport().size.y
	var scale = viewportWidth / $Sprite.texture.get_size().x
	$Sprite.set_scale(Vector2(scale, scale))
	
func _startCombat(var token):
	visible = true
	var combatlane = load("res://Scenes/GUI/Gameplay/Combat/CombatLane/combat_lane.tscn").instance()
	combatlane.add_to_group("combatLane")
	add_child(combatlane)
	combatlane.position = $Sprite.texture.get_size()/3
	combatlane._addToken(token)

func _endCombatPhase(var phase):
	get_tree().call_group("combatLane", "_endCombatPhase", phase)
