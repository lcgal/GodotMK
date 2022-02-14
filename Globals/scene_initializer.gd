extends Node

func start_new_game():
	var game_scene_instance = load("res://Scenes/game.tscn").instance()
	game_scene_instance._newGame()


func card(var card):
	if card == "Blood":
		blood()
	else:
		var card_scene_instance = load("res://Scenes/Cards/card.tscn").instance()
		var card_sprite = GameVariables.action_cards["Basic"]["Cards"][card]["Image"]
		card_scene_instance.name = card
		card_scene_instance.effects = GameVariables.action_cards["Basic"]["Cards"][card]["Effects"]
		card_scene_instance.set_sprite(Assets.card(card_sprite))
		StateController.hand_area.add_card(card_scene_instance)
		

func blood():
	var card_scene_instance = load("res://Scenes/Cards/card.tscn").instance()
	card_scene_instance.name = "blood"
	card_scene_instance.set_sprite(Assets.blood())
	StateController.hand_area.add_card(card_scene_instance)


func explorable_tiles():
	for key in GameVariables.explorable_tiles_info:
		var info = GameVariables.explorable_tiles_info[key]
		if !info.Explored:
			var y = info["Y"]
			var x = info["X"]
			var adjacent_tiles = info["AdjacentTiles"]
			var explore_tile_instance = load("res://Scenes/Map/explorable_tile.tscn").instance()
			explore_tile_instance.set_name(key)
			explore_tile_instance.key = key
			explore_tile_instance.adjacent_tiles = adjacent_tiles
			explore_tile_instance.global_position = y*GameVariables.y_vector + x*GameVariables.x_vector
			StateController.board.add_child(explore_tile_instance)
			explore_tile_instance.connect("explore_tile",StateController.board,"handle_explore_tile")


func portal():
	var map_tile_instance = load("res://Scenes/Map/Tiles/map_tile.tscn").instance()
	var map_tile_info = GameVariables.map_tile_info["Portals"]["Wedge"]
	map_tile_instance.set_tile(map_tile_info)
	StateController.board.add_child(map_tile_instance)


func map_tile(var key, var tile, var pos, var saved_features = null):
	var map_tile_instance = load("res://Scenes/Map/Tiles/map_tile.tscn").instance()
	map_tile_instance.set_name("explored" + key)
	StateController.board.add_child(map_tile_instance)
	map_tile_instance.global_position = pos
	map_tile_instance.set_tile(tile, saved_features)


func player(var knight):
	var player_data = Configs.get_knight_info(knight)
	var player_instance = load("res://Scenes/Players/player.tscn").instance()
	player_instance.set_name("Player1")
	player_instance.deck = player_data["Deck"]
	add_child(player_instance)
	StateController.player1 = player_instance


func feature(var feature_info, var saved_feature, var hex):
	var feature_instance = load("res://Scenes/Map/Tiles/Hex/Feature/feature.tscn").instance()
	hex.add_child(feature_instance)
	feature_instance._setFeature(feature_info, saved_feature)
	feature_instance.set_name("Feature")
	hex.feature = hex.get_node("Feature")


func feature_token(var color, var saved_info, var parent):
	if saved_info == null or saved_info["active"]:
		var token_instance = load("res://Scenes/Map/Tiles/Hex/Feature/token.tscn").instance()
		parent.add_child(token_instance)
		token_instance.create_token(color, saved_info)
		token_instance.set_name("token")
		StateController.board_tokens.append({"Position": token_instance.global_position, "Token" : token_instance})
		return token_instance


func combat_token(var color, var saved_info):
	var token_instance = load("res://Scenes/Map/Tiles/Hex/Feature/token.tscn").instance()
	token_instance.create_token(color, saved_info)
	token_instance.set_name("token")
	return token_instance


func load_item(var item):
	var load_item_instance = load("res://Scenes/GUI/Menu/LoadMenu/load_item.tscn").instance()
	load_item_instance.set_item(item)
	return load_item_instance
