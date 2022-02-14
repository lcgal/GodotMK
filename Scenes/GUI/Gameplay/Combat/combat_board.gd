extends Control

func _ready():
	StateController.combat_board = self
	var scale = GameVariables.DefaultResolution.x / $Sprite.texture.get_size().x
	$Sprite.set_scale(Vector2(scale, scale))
	
func start_combat(var token):
	visible = true
	var combat_lane = load("res://Scenes/GUI/Gameplay/Combat/CombatLane/combat_lane.tscn").instance()
	combat_lane.add_to_group("combat_lane")
	add_child(combat_lane)
	combat_lane.position = $Sprite.texture.get_size()/3
	combat_lane.add_token(token)

func end_combat_phase(var phase):
	get_tree().call_group("combat_lane", "end_combat_phase", phase)
