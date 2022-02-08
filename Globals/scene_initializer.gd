extends Node

func start_new_game():
	var game_scene_instance = load("res://Scenes/game.tscn").instance()
	game_scene_instance._newGame()

func card(var card):
	var card_scene_instance = load("res://Scenes/Cards/card.tscn").instance()
	var card_sprite = GameVariables.action_cards["Basic"]["Cards"][card]["Image"]
	card_scene_instance.name = card
	card_scene_instance.effects = GameVariables.action_cards["Basic"]["Cards"][card]["Effects"]
	card_scene_instance.set_sprite(Assets.card(card_sprite))
	StateController.hand_area._addCard(card_scene_instance)

func blood():
	var card_scene_instance = load("res://Scenes/Cards/card.tscn").instance()
	card_scene_instance.name = "blood"
	card_scene_instance.set_sprite(Assets.blood())
	StateController.hand_area._addCard(card_scene_instance)

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
			explore_tile_instance.connect("exploreTile",StateController.board,"handle_explore_tile")

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

func feature(var feature_info, var hex):
	var feature_instance = load("res://Scenes/Map/Tiles/Hex/Feature/feature.tscn").instance()
	hex.add_child(feature_instance)
	feature_instance._setFeature(feature_info)
	feature_instance.set_name("Feature")
	hex.feature = hex.get_node("Feature")

func token(var feature_info, var feature):
		var token_instance = load("res://Scenes/Map/Tiles/Hex/Feature/token.tscn").instance()
		feature.add_child(token_instance)
		token_instance.create_token(feature_info["Token"])
		token_instance.set_name("token")
		feature.hex_token = feature.get_node("token")

func load_item(var item):
	var load_item_instance = load("res://Scenes/GUI/Menu/LoadMenu/load_item.tscn").instance()
	load_item_instance.set_item(item)
	return load_item_instance
