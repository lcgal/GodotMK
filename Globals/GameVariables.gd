extends Node

var player1
var board
var handGUI
var combatBoard




#Map
var xVector = Vector2(381,-323)
var yVector = Vector2(-95,-484)
var explorableTilesInfo = {}
var mapTileInfo = {}
var countrySideTileList = []
var coreTileList = []
var unusedCoreTileList = []
var scenarioCountryTilesLeft
var scenarioCoreTilesLeft
var scenarioCityCount
var cityTiles = []
var coreTiles = []
var movementCosts
var currentMovementCost = 0
var hexFeatures = []
var tileDistance = 200
var hexDistance = 200


#Cards
var actionCards 

func _ready():
	actionCards = Configs._loadCardsActions()
