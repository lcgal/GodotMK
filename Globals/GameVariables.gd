extends Node

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



#Cards
var actionCards 

func _ready():
	actionCards = Configs._loadCardsActions()
	StateController.gameVariables = self

var savableProperties = [
	"explorableTilesInfo",
	"mapTileInfo",
	"countrySideTileList",
	"coreTileList",
	"scenarioCountryTilesLeft",
	"scenarioCoreTilesLeft",
	"scenarioCityCount",
	"cityTiles",
	"coreTiles",
	"greyTokens",
	"movementCosts",
	"tokensInfo",
	"greyTokens",
	"actionCards"
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
