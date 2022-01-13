extends Node

var player1
var player1Panel
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
var boardTokens = []
var tileDistance = 200
var hexDistance = 200
var tokensInfo
var greyTokens = []


#Cards
var actionCards 

func _ready():
	actionCards = Configs._loadCardsActions()
