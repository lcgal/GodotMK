extends Node

var gameName

#Map
var xVector = Vector2(381,-323)
var yVector = Vector2(-95,-484)
var explorableTilesInfo = {}
var mapTileInfo = {}
var countrySideTileList = []
var coreTileList = []
var scenarioCountryTilesLeft
var scenarioCoreTilesLeft
var scenarioCityCount
var cityTiles = []
var coreTiles = []
var movementCosts
var currentMovementCost = 0
var tileDistance = 200
var hexDistance = 200
var tokensInfo
var greyTokens = []
var available_tokens = {}



#Cards
var actionCards 

func _ready():
	actionCards = Configs._loadCardsActions()
	StateController.gameVariables = self

var savableProperties = [
	"gameName",
	"explorableTilesInfo",
	"mapTileInfo",
	"countrySideTileList",
	"coreTileList",
	"scenarioCountryTilesLeft",
	"scenarioCoreTilesLeft",
	"scenarioCityCount",
	"cityTiles",
	"coreTiles",
	"movementCosts",
	"tokensInfo",
	"actionCards",
	"availabe_tokens"
]

var savableObjects = [
	"board",
]

func _save():
	var save_dict = {}
	for key in savableProperties:
		save_dict[key] = get(key)
	
	return save_dict

func _load(var save_dict):
	for key in save_dict:
		set(key, save_dict[key])

func _InitializeMapData(var mapData, var tilesData, var movementData):
	explorableTilesInfo = mapData["ExplorableTiles"]
	scenarioCountryTilesLeft = mapData["CountrysideTiles"]
	scenarioCoreTilesLeft = mapData["CoreTiles"]
	scenarioCityCount = mapData["Cities"]
	mapTileInfo =tilesData
	movementCosts = movementData
	loadMapTileOptions()
		
func loadMapTileOptions():
	randomize()
	for tile in mapTileInfo["CountrySideTiles"]:
		countrySideTileList.append(tile)
	
	for tile in mapTileInfo["CoreTiles"]:
		if (mapTileInfo["CoreTiles"][tile]["isCity"]):
			cityTiles.append(tile)
		else:
			coreTiles.append(tile)

	for _i in range(0,scenarioCityCount,1):
		var index = randi() % cityTiles.size()
		var tile = cityTiles[index]
		cityTiles.remove(index)
		coreTileList.append(tile)
	for _i in range(0,scenarioCoreTilesLeft - scenarioCityCount,1):
		var index = randi() % coreTiles.size()
		var tile = coreTiles[index]
		coreTiles.remove(index)
		coreTileList.append(tile)
