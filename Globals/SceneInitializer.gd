extends Node

func _drawCard(var card):
	var cardScene = load("res://Scenes/Cards/Card.tscn")
	var cardSceneInstance = cardScene.instance()
	var cardSprite = GameVariables.actionCards["Basic"]["Cards"][card]["Image"]
	cardSceneInstance.name = card
	cardSceneInstance.effects = GameVariables.actionCards["Basic"]["Cards"][card]["Effects"]
	cardSceneInstance._setSprite(Assets._card(cardSprite))
	var handGUI = get_tree().get_root().get_node("/root/Game/CanvasLayer/Control/Hand")
	handGUI._addCard(cardSceneInstance)

func _initializeExplorableTiles():
	for key in GameVariables.explorableTilesInfo:
		var info = GameVariables.explorableTilesInfo[key]
		var y = info["Y"]
		var x = info["X"]
		var adjacentTiles = info["AdjacentTiles"]
		var exploreTileScene = load("res://Scenes/Map/ExplorableTile.tscn")
		var exploreTileSceneInstance = exploreTileScene.instance()
		exploreTileSceneInstance.set_name(key)
		exploreTileSceneInstance.key = key
		exploreTileSceneInstance.adjacentTiles = adjacentTiles
		exploreTileSceneInstance.global_position = y*GameVariables.yVector + x*GameVariables.xVector
		GameVariables.board.add_child(exploreTileSceneInstance)
		exploreTileSceneInstance.connect("exploreTile",GameVariables.board,"_handleExploreTile")

func _addPortal():
	var mapTileScene = load("res://Scenes/Map/Tiles/MapTile.tscn")
	var mapTileSceneInstance = mapTileScene.instance()
	var mapTile = GameVariables.mapTileInfo["Portals"]["Wedge"]
	mapTileSceneInstance.setTile(Assets._mapTile(mapTile["Sprite"]))
	mapTileSceneInstance.hexes = mapTile["Hexes"]
	GameVariables.board.add_child(mapTileSceneInstance)
	mapTileSceneInstance.connect("movement",GameVariables.board,"_handleMovement")

func _addMapTile(var tile, var pos):
	var mapTileScene = load("res://Scenes/Map/Tiles/MapTile.tscn")
	var mapTileSceneInstance = mapTileScene.instance()
	mapTileSceneInstance.setTile(Assets._mapTile(tile["Sprite"]))
	mapTileSceneInstance.hexes = tile["Hexes"]
	mapTileSceneInstance.global_position = pos
	GameVariables.board.add_child(mapTileSceneInstance)
	mapTileSceneInstance.connect("movement",GameVariables.board,"_handleMovement")
