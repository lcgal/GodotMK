extends Node2D

#overall Board handles:
#MapTiles
#PlayerMovement

func _ready():
	StateController.board = self

func _initializeNew():
#	emit_signal("setGreenTileCounter",GameVariables.scenarioCountryTilesLeft)
#	emit_signal("setBrownTileCounter",GameVariables.scenarioCoreTilesLeft)
	_initializeExplorableTiles()
	SceneInitializer._addPortal()
	var tile : ExplorableTile = get_node("B1")
	tile.explore()
	tile = get_node("A2")
	tile.explore()
	GameVariables.currentMovementCost = 0

func _save():
	var save_dict = {}
	
	var explored_tiles_dict = {}
	for key in GameVariables.explorableTilesInfo:
		if GameVariables.explorableTilesInfo[key]["Explored"]:
			var tile = get_node("explored" + key)
			explored_tiles_dict[key] = tile._save()
		
	save_dict["tiles"] = explored_tiles_dict
	
	return save_dict

func _load(var load_dict):
	SceneInitializer._addPortal()
	_initializeExplorableTiles()
	for key in load_dict["tiles"]:
		var tile = load_dict["tiles"][key]
		var position = Converter._string_to_vector2(tile["position"])
		SceneInitializer._addMapTile(key, tile["tile_info"], position, tile["features_info"])

	
	for key in GameVariables.explorableTilesInfo:
		if GameVariables.explorableTilesInfo[key]["Adjacency"] >= 2:
			var adjacentTileNode : ExplorableTile = get_node(key)
			if (adjacentTileNode != null):
				adjacentTileNode.activate()
	pass

#--------------------------BOARD-------------------------------
func _addAdjacency(var key):
	var adjacency = GameVariables.explorableTilesInfo[key]["Adjacency"] + 1
	GameVariables.explorableTilesInfo[key]["Adjacency"] = adjacency
	if (adjacency == 2 && GameVariables.explorableTilesInfo[key]["Explored"]):
		for adjacentTile in GameVariables.explorableTilesInfo[key]["AdjacentTiles"]:
			if (!GameVariables.explorableTilesInfo[adjacentTile["Id"]]["Explored"]):
				var adjacentTileNode : ExplorableTile = get_node(adjacentTile["Id"])
				if (adjacentTileNode != null):
					adjacentTileNode.activate()
#--------------------------END-------------------------------

#--------------------------EXPLORABLETILES---------------------


func _initializeExplorableTiles():
	SceneInitializer._initializeExplorableTiles()

func _handleExploreTile(var explore, var key, var adjacentTiles):
	var player = StateController.player1
	if (player != null):
		if (player.position.distance_to(explore) > 385 || TurnManager.turnPhase != Constants.TurnPhase.MOVEMENT):
			return
		player.move(-2)
		if (!TurnManager._lockActions()):
			player.move(+2)
			return
	
	randomize()
	
	var mapTile 
	if (GameVariables.scenarioCountryTilesLeft > 0) :
		var index = randi() % GameVariables.countrySideTileList.size()
		var mapTileId = GameVariables.countrySideTileList[index]
		GameVariables.countrySideTileList.remove(index)
		GameVariables.scenarioCountryTilesLeft -= 1
		mapTile = GameVariables.mapTileInfo["CountrySideTiles"][mapTileId]
		emit_signal("setGreenTileCounter",GameVariables.scenarioCountryTilesLeft)
	elif (GameVariables.scenarioCoreTilesLeft > 0) :
		var index = randi() % GameVariables.coreTileList.size()
		var mapTileId = GameVariables.coreTileList[index]
		GameVariables.coreTileList.remove(index)
		GameVariables.scenarioCoreTilesLeft -= 1
		mapTile = GameVariables.mapTileInfo["CoreTiles"][mapTileId]
		emit_signal("setBrownTileCounter",GameVariables.scenarioCoreTilesLeft)
	else:
		var index = randi() % GameVariables.countrySideTileList.size()
		var mapTileId = GameVariables.countrySideTileList[index]
		GameVariables.countrySideTileList.remove(index)
		mapTile = GameVariables.mapTileInfo["CountrySideTiles"][mapTileId]
	
	SceneInitializer._addMapTile(key, mapTile, explore)
	
	GameVariables.explorableTilesInfo[key]["Explored"] = true
	GameVariables.currentMovementCost += GameVariables.movementCosts["Day"]["Explore"]
	emit_signal("setCurrentMovementCost",GameVariables.currentMovementCost)
	get_node(key).queue_free()
	
	for tile in adjacentTiles:
		if (GameVariables.explorableTilesInfo[key]["Adjacency"] >= 2):
			if (!GameVariables.explorableTilesInfo[tile["Id"]]["Explored"]):
				var adjacentTileNode : ExplorableTile = get_node(tile["Id"])
				if (adjacentTileNode != null):
					adjacentTileNode.activate()
		_addAdjacency(tile["Id"])

#--------------------------END-------------------------------

#--------------------------MAPTILES--------------------------


signal setGreenTileCounter(values)
signal setBrownTileCounter(values)

#--------------------------END-------------------------------

#--------------------------PLAYERS---------------------
signal setCurrentMovementCost(value)
var startPos

func _handleMovement(var pos, var terrain, lock = false):
	if (startPos == null):
		startPos = StateController.player1.position
	var origin = StateController.player1.position 
	var destination = pos
	if (StateController.player1.position.distance_to(destination) < GameVariables.hexDistance && StateController.player1.position != destination):
		var movementcost = GameVariables.movementCosts["Day"][terrain]
		if (movementcost != null):
			StateController.player1.position = destination
			StateController.player1.move(-movementcost)
			if lock:
				if (!TurnManager._lockActions()):
					StateController.player1.position = origin
					StateController.player1.move(+movementcost)
					return false
			if !_checkTokens():
				StateController.player1.position = origin
				StateController.player1.move(+movementcost)
				return false
				
			emit_signal("setCurrentMovementCost",GameVariables.currentMovementCost)
			return true


func _checkTokens():
	for feature in StateController.boardTokens:
		if !feature["Revealed"]:
			if StateController.player1.position.distance_to(Converter._string_to_vector2(feature["Position"])) < GameVariables.hexDistance:
				if (TurnManager._lockActions()):
					feature["Token"]._reveal()
					feature["Revealed"] = true
				else:
					return false
	return true

func _movementReset():
	if (startPos != null):
		StateController.player1.position = startPos
		GameVariables.currentMovementCost = 0
		emit_signal("setCurrentMovementCost",GameVariables.currentMovementCost)

#--------------------------END-------------------------------



