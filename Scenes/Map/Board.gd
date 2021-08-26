extends Node2D

signal setGreenTileCounter(values)
signal setBrownTileCounter(values)

var origin = Vector2(-560,1317)
var yVector = Vector2(-96,-484)
var xVector = Vector2(380,-321)

var root = "/root/Node2D/Board/"

func _ready():
	initializeMapTiles()
	getTiles()
	var tile : ExplorableTile = get_tree().get_root().get_node(root + "B1")
	tile.explore()
	tile = get_tree().get_root().get_node(root + "A2")
	tile.explore()
	
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

func getTiles():
	var file = File.new()
	file.open("res://Assets/MapTiles/WedgeMapTiles.json",file.READ)
	var tileJson = file.get_as_text()
	file.close()
	explorableTilesInfo = JSON.parse(tileJson).result
	for key in explorableTilesInfo:
		instExplorableTile(explorableTilesInfo[key], key)

func handleExploreTile(var explore, var key, var adjacentTiles):
	randomize()
	
	
	var mapTileScene = load("res://Scenes/Map/Tiles/MapTile.tscn")
	var mapTileSceneInstance = mapTileScene.instance()
	
	if (scenarioCountryTilesLeft > 0) :
		var index = randi() % countrySideTileList.size()
		var mapTileId = countrySideTileList[index]
		countrySideTileList.remove(index)
		scenarioCountryTilesLeft -= 1
		var mapTile = mapTileInfo["CountrySideTiles"][mapTileId]
		mapTileSceneInstance.setTile(rootSpritePath + mapTile["Sprite"]) 
		emit_signal("setGreenTileCounter",scenarioCountryTilesLeft)
	elif (scenarioCoreTilesLeft > 0) :
		var index = randi() % coreTileList.size()
		var mapTileId = coreTileList[index]
		coreTileList.remove(index)
		scenarioCoreTilesLeft -= 1
		var mapTile = mapTileInfo["CoreTiles"][mapTileId]
		mapTileSceneInstance.setTile(rootSpritePath + mapTile["Sprite"]) 
		emit_signal("setBrownTileCounter",scenarioCoreTilesLeft)
	else:
		var index = randi() % countrySideTileList.size()
		var mapTileId = countrySideTileList[index]
		countrySideTileList.remove(index)
		var mapTile = mapTileInfo["CountrySideTiles"][mapTileId]
		mapTileSceneInstance.setTile(rootSpritePath + mapTile["Sprite"]) 
		
	mapTileSceneInstance.global_position = explore
	add_child(mapTileSceneInstance)
	explorableTilesInfo[key]["Explored"] = true
	for tile in adjacentTiles:
		if (explorableTilesInfo[key]["Adjacency"] >= 2):
			if (!explorableTilesInfo[tile["Id"]]["Explored"]):
				var adjacentTileNode : ExplorableTile = get_tree().get_root().get_node(root + tile["Id"])
				if (adjacentTileNode != null):
					adjacentTileNode.activate()
		addAdjacency(tile["Id"])

func instExplorableTile(var info, var key):
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
#--------------------------END-------------------------------

#--------------------------MAPTILES--------------------------
var mapTileInfo = {}
var countrySideTileList = []
var coreTileList = []
var rootSpritePath = "res://Assets/MapTiles/Tiles/"
var scenarioCountryTilesLeft = 7
var scenarioCoreTilesLeft = 6

func initializeMapTiles():
	var file = File.new()
	file.open("res://Assets/MapTiles/CountrySideTiles.json",file.READ)
	var tileJson = file.get_as_text()
	file.close()
	mapTileInfo = JSON.parse(tileJson).result
	for tile in mapTileInfo["CountrySideTiles"]:
		countrySideTileList.append(tile)
	for tile in mapTileInfo["CoreTiles"]:
		coreTileList.append(tile)
		
	emit_signal("setGreenTileCounter",scenarioCountryTilesLeft)
	emit_signal("setBrownTileCounter",scenarioCoreTilesLeft)

#--------------------------END-------------------------------
