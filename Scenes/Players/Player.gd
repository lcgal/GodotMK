extends Node2D
var knight

var hand_GUI

var deck
var hand = []
var discard = []
var handSize = 0
var handLimit = 5
var armor = 3
var experience = 0

var movementPoints = 0

signal updateDeckCount(count)

var savable_attr = [
	"knight",
	"deck",
	"hand",
	"discard",
	"handSize",
	"handLimit",
	"armor",
	"experience",
	"movementPoints",
	"position",
]

func _ready():
	var deckGUI = get_tree().get_root().get_node("/root/Game/CanvasLayer/Control/Deck")
	deckGUI._connect(self)
	hand_GUI = StateController.hand_area
	emit_signal("updateDeckCount",deck.size())


func _save():
	var save_dict = {}
	for key in savable_attr:
		save_dict[key] = get(key)
	return save_dict

func load_player(var load_dict):
	pass

func _drawCard():
	randomize()
	var index = randi() % deck.size()
	var card = deck[index]
	deck.remove(index)
	hand.append(card)
	emit_signal("updateDeckCount",deck.size())
	SceneInitializer._drawCard(card)
	handSize += 1

func _drawToHandLimit():
	while handSize < handLimit:
		_drawCard()

func _resetTurn():
	movementPoints = 0
	TurnManager._updateMovementPoints(movementPoints)
	hand_GUI._resetTurn()

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


func lock_cards():
	hand_GUI._lockPlayedCards()


func discard_cards():
	hand_GUI._discardCards()


func _quit():
	queue_free()
