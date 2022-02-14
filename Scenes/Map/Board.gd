extends Node2D

#overall Board handles:
#MapTiles
#PlayerMovement

func _ready():
	StateController.board = self

func _initializeNew():
	SceneInitializer.explorable_tiles()
	SceneInitializer.portal()
	var tile : ExplorableTile = get_node("B1")
	tile.explore()
	tile = get_node("A2")
	tile.explore()
	GameVariables.current_movement_cost = 0
	emit_signal("set_greentiles_counter",GameVariables.countryside_tiles_left)
	emit_signal("set_browntiles_counter",GameVariables.core_tiles_left)

func save_game():
	var save_dict = {}
	
	var explored_tiles_dict = {}
	for key in GameVariables.explorable_tiles_info:
		if GameVariables.explorable_tiles_info[key]["Explored"]:
			var tile = get_node("explored" + key)
			explored_tiles_dict[key] = tile.save_game()
		
	save_dict["tiles"] = explored_tiles_dict
	
	return save_dict

func load_game(var load_dict):
	SceneInitializer.portal()
	SceneInitializer.explorable_tiles()
	for key in load_dict["tiles"]:
		var tile = load_dict["tiles"][key]
		var position = Converter.string_to_vector2(tile["position"])
		SceneInitializer.map_tile(key, tile["tile_info"], position, tile["features_info"])
	emit_signal("set_greentiles_counter",GameVariables.countryside_tiles_left)
	emit_signal("set_browntiles_counter",GameVariables.core_tiles_left)


	for key in GameVariables.explorable_tiles_info:
		if GameVariables.explorable_tiles_info[key]["Adjacency"] >= 2 && !GameVariables.explorable_tiles_info[key]["Explored"]:
			var adjacent_tile_node : ExplorableTile = get_node(key)
			if (adjacent_tile_node != null):
				adjacent_tile_node.activate()
	pass

#--------------------------BOARD-------------------------------
func _add_adjacency(var key):
	var adjacency = GameVariables.explorable_tiles_info[key]["Adjacency"] + 1
	GameVariables.explorable_tiles_info[key]["Adjacency"] = adjacency
	if (adjacency == 2 && GameVariables.explorable_tiles_info[key]["Explored"]):
		for adjacent_tile in GameVariables.explorable_tiles_info[key]["AdjacentTiles"]:
			if (!GameVariables.explorable_tiles_info[adjacent_tile["Id"]]["Explored"]):
				var adjacent_tile_node : ExplorableTile = get_node(adjacent_tile["Id"])
				if (adjacent_tile_node != null):
					adjacent_tile_node.activate()
#--------------------------END-------------------------------

#--------------------------EXPLORABLETILES---------------------

func handle_explore_tile(var explore, var key, var adjacent_tiles):
	var player = StateController.player1
	if is_instance_valid(player):
		if (player.position.distance_to(explore) > 385 || TurnManager.turn_phase != Constants.turn_phase.MOVEMENT):
			return
		player.move(-2)
		if (!TurnManager._lockActions()):
			player.move(+2)
			return
	
	randomize()
	
	var mapTile 
	if (GameVariables.countryside_tiles_left > 0) :
		var index = randi() % GameVariables.countryside_tile_list.size()
		var mapTileId = GameVariables.countryside_tile_list[index]
		GameVariables.countryside_tile_list.remove(index)
		GameVariables.countryside_tiles_left -= 1
		mapTile = GameVariables.map_tile_info["CountrySideTiles"][mapTileId]
		emit_signal("set_greentiles_counter",GameVariables.countryside_tiles_left)
	elif (GameVariables.core_tiles_left > 0) :
		var index = randi() % GameVariables.core_tile_list.size()
		var mapTileId = GameVariables.core_tile_list[index]
		GameVariables.core_tile_list.remove(index)
		GameVariables.core_tiles_left -= 1
		mapTile = GameVariables.map_tile_info["core_tiles"][mapTileId]
		emit_signal("set_browntiles_counter",GameVariables.core_tiles_left)
	else:
		var index = randi() % GameVariables.countryside_tile_list.size()
		var mapTileId = GameVariables.countryside_tile_list[index]
		GameVariables.countryside_tile_list.remove(index)
		mapTile = GameVariables.map_tile_info["CountrySideTiles"][mapTileId]
	
	SceneInitializer.map_tile(key, mapTile, explore)
	
	GameVariables.explorable_tiles_info[key]["Explored"] = true
	GameVariables.current_movement_cost += GameVariables.movement_costs["Day"]["Explore"]
	emit_signal("set_current_movement_cost",GameVariables.current_movement_cost)
	get_node(key).queue_free()
	
	for tile in adjacent_tiles:
		if (GameVariables.explorable_tiles_info[key]["Adjacency"] >= 2):
			if (!GameVariables.explorable_tiles_info[tile["Id"]]["Explored"]):
				var adjacent_tile_node : ExplorableTile = get_node(tile["Id"])
				if (adjacent_tile_node != null):
					adjacent_tile_node.activate()
		_add_adjacency(tile["Id"])

#--------------------------END-------------------------------

#--------------------------MAPTILES--------------------------


signal set_greentiles_counter(values)
signal set_browntiles_counter(values)

#--------------------------END-------------------------------

#--------------------------PLAYERS---------------------
signal set_current_movement_cost(value)
var start_pos

func handle_movement(var pos, var terrain, lock = false):
	if (start_pos == null):
		start_pos = StateController.player1.position
	var origin = StateController.player1.position 
	var destination = pos
	if (StateController.player1.position.distance_to(destination) < GameVariables.hex_distance && StateController.player1.position != destination):
		var movement_cost = GameVariables.movement_costs["Day"][terrain]
		if (movement_cost != null):
			StateController.player1.position = destination
			StateController.player1.move(-movement_cost)
			if lock:
				if (!TurnManager.lockable()):
					StateController.player1.position = origin
					StateController.player1.move(+movement_cost)
					return false
			if !_check_tokens():
				StateController.player1.position = origin
				StateController.player1.move(+movement_cost)
				return false
				
			emit_signal("set_current_movement_cost",GameVariables.current_movement_cost)
			return true


func _check_tokens():
	for token in StateController.board_tokens:
		if !token["Token"].revealed:
			if StateController.player1.position.distance_to(Converter.string_to_vector2(token["Position"])) < GameVariables.hex_distance:
				if (TurnManager.lockable()):
					token["Token"]._reveal()
					token["Revealed"] = true
					TurnManager.lock_actions()
				else:
					return false
	return true

func reset_actions():
	if (start_pos != null):
		StateController.player1.position = start_pos
		GameVariables.current_movement_cost = 0
		emit_signal("set_current_movement_cost",GameVariables.current_movement_cost)

func quit_game():
	queue_free()
#--------------------------END-------------------------------



