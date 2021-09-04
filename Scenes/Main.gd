extends Node2D
var root = "/root/Game/"

var board

func _ready():
	board = $Board
	_initializePlayer(Constants.Knights.TOVAK)
	_drawCard()
	_drawCard()
	_drawCard()
	_drawCard()
	_drawCard()



func _drawCard():
	var card = GameVariables.player1._draw()
	var cardScene = load("res://Scenes/Cards/Card.tscn")
	var cardSceneInstance = cardScene.instance()
	var cardSprite = GameVariables.actionCards["Basic"]["Cards"][card]["Image"]
	cardSceneInstance.name = card
	cardSceneInstance._setSprite(Assets._card(cardSprite))
	var handGUI = get_tree().get_root().get_node("/root/Game/CanvasLayer/Control/Hand")
	handGUI._addCard(cardSceneInstance)




func _initializePlayer(var knight):
	var parsedPlayerData = Configs._loadKnight(knight)
	var playerScene = load("res://Scenes/Players/Player.tscn")
	var playerSceneInstance = playerScene.instance()
	playerSceneInstance.set_name("Player1")
	playerSceneInstance.deck = parsedPlayerData["Deck"]
	add_child(playerSceneInstance)
	GameVariables.player1 = playerSceneInstance

