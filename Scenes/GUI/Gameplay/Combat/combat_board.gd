extends Control

func _ready():
	StateController.combat_board = self
	var scale = GameVariables.DefaultResolution.x / $Sprite.texture.get_size().x
	$Sprite.set_scale(Vector2(scale, scale))


func save_game():
	var save_dict = {}
	
	save_dict["visible"] = visible
	var combat_lanes = {}
	for combat_lane in get_tree().get_nodes_in_group("combat_lane"):
		combat_lanes[combat_lane.name] = combat_lane.save_game()
	
	save_dict["combat_lanes"] = combat_lanes
	return save_dict


func load_game(var load_dict):
	
	visible = load_dict["visible"]
	for combat_lane in load_dict["combat_lanes"]:
		var token_info = load_dict["combat_lanes"][combat_lane]
		var token = SceneInitializer.combat_token(token_info["color"], token_info)
		start_combat(token)
			


func start_combat(var token):
	visible = true
	var combat_lane = load("res://Scenes/GUI/Gameplay/Combat/CombatLane/combat_lane.tscn").instance()
	combat_lane.name = "lane_1"
	combat_lane.add_to_group("combat_lane")
	add_child(combat_lane)
	combat_lane.position = $Sprite.texture.get_size()/3
	combat_lane.add_token(token)


func end_combat_phase(var phase):
	get_tree().call_group("combat_lane", "end_combat_phase", phase)
	


func end_combat():
	visible = false


