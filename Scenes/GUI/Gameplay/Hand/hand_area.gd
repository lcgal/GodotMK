extends Control
var origin = Vector2(-560,1317)

onready var CentreCardOval = get_viewport().size * Vector2(0, 0.95)
onready var Hor_rad = get_viewport().size.x*1
onready var Ver_rad = get_viewport().size.y*0.8
var CardSize
var CardSpread
var normalScale = Vector2(0.4,0.4)
var highlightScale = Vector2(0.6,0.6)


func _ready():
	StateController.handGUI = self

func _resetTurn():
	for handCard in get_tree().get_nodes_in_group("cards"):
		if !handCard.locked:
			handCard._setAsPlayStatus(false)

func _addCard(var card):
	card.number = StateController.player1.handSize
	card.scale = normalScale
	if CardSize == null:
		CardSize = card.get_node("Sprite").texture.get_size()
	if CardSpread == null:
		CardSpread = 0.0004*CardSize.x
	add_child(card)
	card.add_to_group("cards")
	card.connect("highlight",self,"_handleHighlight")
	
	_reorganize(false, null)


func _handleHighlight(var highlight, cardNumber):
	if (highlight):
		_reorganize(true, cardNumber)
	else:
		_reorganize(false, cardNumber)
	
#TODO FIXME when fastly swapping between cards this does not work properly
func _reorganize(var highlight, var highlightedcard):
	var i = 0
	for handCard in get_tree().get_nodes_in_group("cards"):
		handCard.number = i
		i += 1
		var angle = -PI/2 + CardSpread*(float(StateController.player1.handSize - 1)/2 - handCard.number)
		if (highlight && handCard.number > highlightedcard):
			angle -= CardSpread*0.8
		elif (highlight && handCard.number < highlightedcard):
			angle += CardSpread*0.8
		elif (highlightedcard != null && handCard.number == highlightedcard):
			if (highlight):
				handCard.scale = highlightScale
			else:
				handCard.scale = normalScale
		
		var OvalAngleVector = Vector2(Hor_rad * cos(angle),Ver_rad * sin(angle))
		var pos = CentreCardOval + OvalAngleVector - Vector2(CardSize.x/2,CardSize.y)
		handCard.position = pos
		handCard.rotation = (90+rad2deg(angle))/90

func _lockPlayedCards():
	for handCard in get_tree().get_nodes_in_group("cards"):
		if handCard.played:
			handCard.locked = true

func _discardCards():
	for handCard in get_tree().get_nodes_in_group("cards"):
		if handCard.played:
			handCard.queue_free()
			StateController.player1.handSize -= 1
	_reorganize(false, null)
