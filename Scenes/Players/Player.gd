extends Node2D
var knight

var deck
var discard = []
var handSize = 0
var handLimit = 5

var movementPoints = 0

signal updateDeckCount(count)

func _ready():
	var deckGUI = get_tree().get_root().get_node("/root/Game/CanvasLayer/Control/Deck")
	deckGUI._connect(self)
	emit_signal("updateDeckCount",deck.size())

func _drawCard():
	randomize()
	var index = randi() % deck.size()
	var card = deck[index]
	deck.remove(index)
	discard.append(card)
	emit_signal("updateDeckCount",deck.size())
	SceneInitializer._drawCard(card)
	handSize+=1

func _drawToHandLimit():
	while handSize < handLimit:
		_drawCard()

func _resetTurn():
	print(movementPoints)
	movementPoints = 0
	TurnManager._updateMovementPonts(movementPoints)

func move(var movePoints):
	movementPoints += movePoints
	TurnManager._updateMovementPonts(movementPoints)
	
func _drawBlood(var qtd):
	for i in range(0, qtd, 1):
		SceneInitializer._drawBlood()
