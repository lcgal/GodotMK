extends Node2D

#overall Board handles:
#MapTiles
#PlayerMovement

var xVector = Vector2(381,-323)
var yVector = Vector2(-95,-484)

var root = "/root/Game/Board/"
var rootJsons = "res://ConfigJsons/"

func _ready():
	_initialize()
	_addPortal()
	var tile : ExplorableTile = get_tree().get_root().get_node(root + "B1")
	tile.explore()
	tile = get_tree().get_root().get_node(root + "A2")
	tile.explore()

func _initialize():
	_readConfigfies()
	_initializeMapTiles()
	_initializeExplorableTiles()

func _readConfigfies():
	_readScenarioInfo()
	_readTilesInfo()
	_readMovementInfo()

func _readScenarioInfo():
	var parsedData = Configs._loadMap(Constants.Maps.WEDGE)
	explorableTilesInfo = parsedData["ExplorableTiles"]
	scenarioCountryTilesLeft = parsedData["CountrysideTiles"]
	scenarioCoreTilesLeft = parsedData["CoreTiles"]
	scenarioCityCount = parsedData["Cities"]

func _readTilesInfo():
	var file = File.new()
	file.open(rootJsons +"MapTiles.json",file.READ)
	var tileJson = file.get_as_text()
	file.close()
	mapTileInfo = JSON.parse(tileJson).result
	
func _readMovementInfo():
	var file = File.new()
	file.open(rootJsons + "MovementCosts.json",file.READ)
	var tileJson = file.get_as_text()
	file.close()
	movementCosts = JSON.parse(tileJson).result
#--------------------------BOARD-------------------------------

func _addAdjacency(var key):
	var adjacency = explorableTilesInfo[key]["Adjacency"] + 1
	explorableTilesInfo[key]["Adjacency"] = adjacency
	if (adjacency == 2 && explorableTilesInfo[key]["Explored"]):
		for adjacentTile in explorableTilesInfo[key]["AdjacentTiles"]:
			if (!explorableTilesInfo[adjacentTile["Id"]]["Explored"]):
				var adjacentTileNode : ExplorableTile = get_tree().get_root().get_node(root + adjacentTile["Id"])
				if (adjacentTileNode != null):
					adjacentTileNode.activate()
#--------------------------END-------------------------------

#--------------------------EXPLORABLETILES---------------------
var explorableTilesInfo = {}

func _initializeExplorableTiles():
	for key in explorableTilesInfo:
		var info = explorableTilesInfo[key]
		var y = info["Y"]
		var x = info["X"]
		var adjacentTiles = info["AdjacentTiles"]
		var exploreTileScene = load("res://Scenes/Map/ExplorableTile.tscn")
		var exploreTileSceneInstance = exploreTileScene.instance()
		exploreTileSceneInstance.set_name(key)
		exploreTileSceneInstance.key = key
		exploreTileSceneInstance.adjacentTiles = adjacentTiles
		exploreTileSceneInstance.global_position = y*yVector + x*xVector
		add_child(exploreTileSceneInstance)
		exploreTileSceneInstance.connect("exploreTile",self,"_handleExploreTile")


func _handleExploreTile(var explore, var key, var adjacentTiles):
	var player = GameVariables.player1
	if (player != null && player.position.distance_to(explore) > 385):
		return
	
	randomize()

	var mapTileScene = load("res://Scenes/Map/Tiles/MapTile.tscn")
	var mapTileSceneInstance = mapTileScene.instance()
	
	var mapTile 
	if (scenarioCountryTilesLeft > 0) :
		var index = randi() % countrySideTileList.size()
		var mapTileId = countrySideTileList[index]
		countrySideTileList.remove(index)
		scenarioCountryTilesLeft -= 1
		mapTile = mapTileInfo["CountrySideTiles"][mapTileId]
		emit_signal("setGreenTileCounter",scenarioCountryTilesLeft)
	elif (scenarioCoreTilesLeft > 0) :
		var index = randi() % coreTileList.size()
		var mapTileId = coreTileList[index]
		coreTileList.remove(index)
		scenarioCoreTilesLeft -= 1
		mapTile = mapTileInfo["CoreTiles"][mapTileId]
		emit_signal("setBrownTileCounter",scenarioCoreTilesLeft)
	else:
		var index = randi() % countrySideTileList.size()
		var mapTileId = countrySideTileList[index]
		countrySideTileList.remove(index)
		mapTile = mapTileInfo["CountrySideTiles"][mapTileId]
	
	mapTileSceneInstance.setTile(Assets._mapTile(mapTile["Sprite"]))
	mapTileSceneInstance.hexes = mapTile["Hexes"]
	mapTileSceneInstance.global_position = explore
	add_child(mapTileSceneInstance)
	mapTileSceneInstance.connect("movement",self,"_handleMovement")
	explorableTilesInfo[key]["Explored"] = true
	currentMovementCost += movementCosts["Day"]["Explore"]
	emit_signal("setCurrentMovementCost",currentMovementCost)
	get_tree().get_root().get_node(root + key).queue_free()
	
	for tile in adjacentTiles:
		if (explorableTilesInfo[key]["Adjacency"] >= 2):
			if (!explorableTilesInfo[tile["Id"]]["Explored"]):
				var adjacentTileNode : ExplorableTile = get_tree().get_root().get_node(root + tile["Id"])
				if (adjacentTileNode != null):
					adjacentTileNode.activate()
		_addAdjacency(tile["Id"])

func _addPortal():
	var mapTileScene = load("res://Scenes/Map/Tiles/MapTile.tscn")
	var mapTileSceneInstance = mapTileScene.instance()
	var mapTile = mapTileInfo["Portals"]["Wedge"]
	mapTileSceneInstance.setTile(Assets._mapTile(mapTile["Sprite"]))
	mapTileSceneInstance.hexes = mapTile["Hexes"]
	add_child(mapTileSceneInstance)
	mapTileSceneInstance.connect("movement",self,"_handleMovement")

#--------------------------END-------------------------------

#--------------------------MAPTILES--------------------------
var mapTileInfo = {}
var countrySideTileList = []
var coreTileList = []
var unusedCoreTileList = []
var scenarioCountryTilesLeft
var scenarioCoreTilesLeft
var scenarioCityCount

signal setGreenTileCounter(values)
signal setBrownTileCounter(values)

func _initializeMapTiles():
	#Creating Tile options lists
	randomize()
	for tile in mapTileInfo["CountrySideTiles"]:
		countrySideTileList.append(tile)
	
	var cityTiles = []
	var coreTiles = []
	for tile in mapTileInfo["CoreTiles"]:
		if (mapTileInfo["CoreTiles"][tile]["isCity"]):
			cityTiles.append(tile)
		else:
			coreTiles.append(tile)

	for i in range(0,scenarioCityCount,1):
		var index = randi() % cityTiles.size()
		var tile = cityTiles[index]
		cityTiles.remove(index)
		coreTileList.append(tile)
	for i in range(0,scenarioCoreTilesLeft - scenarioCityCount,1):
		var index = randi() % coreTiles.size()
		var tile = coreTiles[index]
		coreTiles.remove(index)
		coreTileList.append(tile)
	
	unusedCoreTileList = coreTiles
	#END
	
	emit_signal("setGreenTileCounter",scenarioCountryTilesLeft)
	emit_signal("setBrownTileCounter",scenarioCoreTilesLeft)

#--------------------------END-------------------------------

#--------------------------PLAYERS---------------------
var movementCosts

signal setCurrentMovementCost(value)
var currentMovementCost = 0
var startPos

func _handleMovement(var pos, var terrain):
	if (startPos == null):
		startPos = GameVariables.player1.position
	var destination = pos
	if (GameVariables.player1.position.distance_to(destination) < 200 && GameVariables.player1.position != destination):
		var movementcost = movementCosts["Day"][terrain]
		if (movementcost != null):
			currentMovementCost += movementcost
			emit_signal("setCurrentMovementCost",currentMovementCost)
			GameVariables.player1.position = pos
			

func _on_Control_reset():
	GameVariables.player1.position = startPos
	startPos = null
	currentMovementCost = 0
	emit_signal("setCurrentMovementCost",currentMovementCost)

#--------------------------END-------------------------------



