extends Node

func _startNewGame():
	var gameScene = load("res://Scenes/game.tscn")
	var gameSceneInstance = gameScene.instance()
	gameSceneInstance._newGame()

func _drawCard(var card):
	var cardScene = load("res://Scenes/Cards/card.tscn")
	var cardSceneInstance = cardScene.instance()
	var cardSprite = GameVariables.actionCards["Basic"]["Cards"][card]["Image"]
	cardSceneInstance.name = card
	cardSceneInstance.effects = GameVariables.actionCards["Basic"]["Cards"][card]["Effects"]
	cardSceneInstance._setSprite(Assets._card(cardSprite))
	var handGUI = get_tree().get_root().get_node("/root/Game/CanvasLayer/Control/Hand")
	handGUI._addCard(cardSceneInstance)

func _drawBlood():
	var cardScene = load("res://Scenes/Cards/Card.tscn")
	var cardSceneInstance = cardScene.instance()
	cardSceneInstance.name = "blood"
	cardSceneInstance._setSprite(Assets._blood())
	var handGUI = get_tree().get_root().get_node("/root/Game/CanvasLayer/Control/hand")
	handGUI._addCard(cardSceneInstance)

func _initializeExplorableTiles():
	for key in GameVariables.explorableTilesInfo:
		var info = GameVariables.explorableTilesInfo[key]
		var y = info["Y"]
		var x = info["X"]
		var adjacentTiles = info["AdjacentTiles"]
		var exploreTileScene = load("res://Scenes/Map/explorable_tile.tscn")
		var exploreTileSceneInstance = exploreTileScene.instance()
		exploreTileSceneInstance.set_name(key)
		exploreTileSceneInstance.key = key
		exploreTileSceneInstance.adjacentTiles = adjacentTiles
		exploreTileSceneInstance.global_position = y*GameVariables.yVector + x*GameVariables.xVector
		StateController.board.add_child(exploreTileSceneInstance)
		exploreTileSceneInstance.connect("exploreTile",StateController.board,"_handleExploreTile")

func _addPortal():
	var mapTileScene = load("res://Scenes/Map/Tiles/map_tile.tscn")
	var mapTileSceneInstance = mapTileScene.instance()
	var mapTile = GameVariables.mapTileInfo["Portals"]["Wedge"]
	mapTileSceneInstance.setTile(mapTile)
	StateController.board.add_child(mapTileSceneInstance)

func _addMapTile(var key, var tile, var pos, var savedFeatures = null):
	var mapTileScene = load("res://Scenes/Map/Tiles/map_tile.tscn")
	var mapTileSceneInstance = mapTileScene.instance()
	mapTileSceneInstance.set_name("explored"+key)
	StateController.board.add_child(mapTileSceneInstance)
	mapTileSceneInstance.global_position = pos
	mapTileSceneInstance.setTile(tile, savedFeatures)

func _initializePlayer(var knight):
	var parsedPlayerData = Configs._loadKnight(knight)
	var playerScene = load("res://Scenes/Players/player.tscn")
	var playerSceneInstance = playerScene.instance()
	playerSceneInstance.set_name("Player1")
	playerSceneInstance.deck = parsedPlayerData["Deck"]
	add_child(playerSceneInstance)
	StateController.player1 = playerSceneInstance

func _initializeFeature(var featureInfo, var hex):
	var featureSceneInstance = load("res://Scenes/Map/Tiles/Hex/Feature/feature.tscn").instance()
	hex.add_child(featureSceneInstance)
	featureSceneInstance._setFeature(featureInfo)
	featureSceneInstance.set_name("Feature")
	hex.feature = hex.get_node("Feature")

func _initializeToken(var featureInfo, var feature):
		var tokenSceneInstance = load("res://Scenes/Map/Tiles/Hex/Feature/token.tscn").instance()
		feature.add_child(tokenSceneInstance)
		tokenSceneInstance._createToken(featureInfo["Token"])
		tokenSceneInstance.set_name("token")
		feature.hexToken = feature.get_node("token")

func initialize_load_item(var item):
	var load_item_instance = load("res://Scenes/GUI/Menu/LoadMenu/load_item.tscn").instance()
	load_item_instance.set_item(item)
	return load_item_instance
