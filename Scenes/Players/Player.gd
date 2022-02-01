extends Node2D
var knight

var deck
var discard = []
var handSize = 0
var handLimit = 5
var armor = 3
var experience = 0

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
	movementPoints = 0
	TurnManager._updateMovementPoints(movementPoints)

func move(var movePoints):
	movementPoints += movePoints
	TurnManager._updateMovementPoints(movementPoints)
	
func _drawBlood(var qtd):
	for _i in range(0, qtd, 1):
		SceneInitializer._drawBlood()
		handSize+=1

func _gainFame(var value):
	experience += value
	var experienceText = TextBuilder._experienceLabelText(experience) 
	
	StateController.player1Panel._setExperienceText(experienceText)
	
func _quit():
	queue_free()
