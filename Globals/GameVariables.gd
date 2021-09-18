extends Node

var player1
var board
var handGUI




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


#Cards
var actionCards 

func _ready():
	actionCards = Configs._loadCardsActions()
