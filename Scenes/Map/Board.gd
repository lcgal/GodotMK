extends Node2D

var origin = Vector2(-560,1317)
var yVector = Vector2(-96,-484)
var xVector = Vector2(380,-321)

var root = "/root/Node2D/Node2D/"

var tilesInfo = {}

func _ready():
	getTiles()
	var tile : ExplorableTile = get_tree().get_root().get_node(root + "B1")
	tile.explore()
	tile = get_tree().get_root().get_node(root + "A2")
	tile.explore()

func handleExploreTile(var explore, var key, var adjacentTiles):
	var mapTileScene = load("res://Scenes/Map/Tiles/MapTile.tscn")
	var mapTileSceneInstance = mapTileScene.instance()
	mapTileSceneInstance.global_position = explore
	add_child(mapTileSceneInstance)
	tilesInfo[key]["Explored"] = true
	for tile in adjacentTiles:
#		print(key + " - " + str(tilesInfo[key]["Adjacency"]))
		if (tilesInfo[key]["Adjacency"] == 2):
			if (!tilesInfo[tile["Id"]]["Explored"]):
				var adjacentTileNode : ExplorableTile = get_tree().get_root().get_node(root + tile["Id"])
				if (adjacentTileNode != null):
					adjacentTileNode.activate()
		addAdjacency(tile["Id"])
	
	

func getTiles():
	var file = File.new()
	file.open("res://Assets/MapTiles/ConquestTiles2.json",file.READ)
	var tileJson = file.get_as_text()
	file.close()
	tilesInfo = JSON.parse(tileJson).result
	for key in tilesInfo:
		instExplorableTile(tilesInfo[key], key)

func addAdjacency(var key):
	var adjacency = tilesInfo[key]["Adjacency"] + 1
	tilesInfo[key]["Adjacency"] = adjacency
	if (adjacency == 2 && tilesInfo[key]["Explored"]):
		for adjacentTile in tilesInfo[key]["AdjacentTiles"]:
			if (!tilesInfo[adjacentTile["Id"]]["Explored"]):
				var adjacentTileNode : ExplorableTile = get_tree().get_root().get_node(root + adjacentTile["Id"])
				if (adjacentTileNode != null):
					adjacentTileNode.activate()


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
