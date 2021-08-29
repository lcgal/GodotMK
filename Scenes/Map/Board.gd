extends Node2D

signal setGreenTileCounter(values)
signal setBrownTileCounter(values)

var origin = Vector2(-560,1317)
var xVector = Vector2(381,-323)
var yVector = Vector2(-95,-484)

var root = "/root/Node2D/Board/"

func _ready():
	initialize()
	addPortal()
	var tile : ExplorableTile = get_tree().get_root().get_node(root + "B1")
	tile.explore()
	tile = get_tree().get_root().get_node(root + "A2")
	tile.explore()


func initialize():
	readConfigfies()
	initializeMapTiles()
	initializeExplorableTiles()
	initializePlayer()

func readConfigfies():
	readScenarioInfo()
	readTilesInfo()

func readScenarioInfo():
	var file = File.new()
	file.open("res://Assets/MapTiles/WedgeMapTiles.json",file.READ)
	var tileJson = file.get_as_text()
	file.close()
	var parsedData = JSON.parse(tileJson).result
	explorableTilesInfo = parsedData["ExplorableTiles"]
	scenarioCountryTilesLeft = parsedData["CountrysideTiles"]
	scenarioCoreTilesLeft = parsedData["CoreTiles"]
	scenarioCityCount = parsedData["Cities"]

func readTilesInfo():
	var file = File.new()
	file.open("res://Assets/MapTiles/MapTiles.json",file.READ)
	var tileJson = file.get_as_text()
	file.close()
	mapTileInfo = JSON.parse(tileJson).result
#--------------------------BOARD-------------------------------

func addAdjacency(var key):
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

func initializeExplorableTiles():
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
		exploreTileSceneInstance.global_position = origin + y*yVector + x*xVector
		add_child(exploreTileSceneInstance)
		exploreTileSceneInstance.connect("exploreTile",self,"handleExploreTile")


func handleExploreTile(var explore, var key, var adjacentTiles):
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
		 

	mapTileSceneInstance.setTile(rootSpritePath + mapTile["Sprite"])
	mapTileSceneInstance.hexes = mapTile["Hexes"]
	mapTileSceneInstance.global_position = explore
	add_child(mapTileSceneInstance)
	mapTileSceneInstance.connect("movement",self,"handleMovement")
	explorableTilesInfo[key]["Explored"] = true
	for tile in adjacentTiles:
		if (explorableTilesInfo[key]["Adjacency"] >= 2):
			if (!explorableTilesInfo[tile["Id"]]["Explored"]):
				var adjacentTileNode : ExplorableTile = get_tree().get_root().get_node(root + tile["Id"])
				if (adjacentTileNode != null):
					adjacentTileNode.activate()
		addAdjacency(tile["Id"])

func addPortal():
	var mapTileScene = load("res://Scenes/Map/Tiles/MapTile.tscn")
	var mapTileSceneInstance = mapTileScene.instance()
	var mapTile = mapTileInfo["Portals"]["Wedge"]
	mapTileSceneInstance.global_position = origin
	mapTileSceneInstance.setTile(rootSpritePath + mapTile["Sprite"])
	mapTileSceneInstance.hexes = mapTile["Hexes"]
	add_child(mapTileSceneInstance)
	mapTileSceneInstance.connect("movement",self,"handleMovement")

#--------------------------END-------------------------------

#--------------------------MAPTILES--------------------------
var mapTileInfo = {}
var countrySideTileList = []
var coreTileList = []
var unusedCoreTileList = []
var rootSpritePath = "res://Assets/MapTiles/Tiles/"
var scenarioCountryTilesLeft
var scenarioCoreTilesLeft
var scenarioCityCount

func initializeMapTiles():
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
func initializePlayer():
	var playerScene = load("res://Scenes/Players/Character/Knight.tscn")
	var playerSceneInstance = playerScene.instance()
	playerSceneInstance.set_name("Player1")
	playerSceneInstance.global_position = origin
	add_child(playerSceneInstance)
#	playerSceneInstance.connect("exploreTile",self,"handleExploreTile")

func handleMovement(var pos, var terrain):
	var player = get_tree().get_root().get_node(root + "Player1")
	player.position = origin + pos
#--------------------------END-------------------------------
