extends Control
var origin = Vector2(-560,1317)

onready var CentreCardOval = get_viewport().size * Vector2(0, 1.25)
onready var Hor_rad = get_viewport().size.x*2
onready var Ver_rad = get_viewport().size.y*1
var CardSize
var CardSpread
var NumberCardsHand = 0
var normalScale = Vector2(0.4,0.4)
var highlightScale = Vector2(0.6,0.6)

func _ready():
	pass



func _addCard(var card):
	card.number = NumberCardsHand
	NumberCardsHand += 1
	card.scale = normalScale
	if CardSize == null:
		CardSize = card.get_node("Sprite").texture.get_size()
	if CardSpread == null:
		CardSpread = 0.0003*CardSize.x
	add_child(card)
	card.add_to_group("cards")
	card.connect("highlight",self,"_handleHighlight")
	
	_reOrganize(false, null)


func _handleHighlight(var highlight, cardNumber):
	if (highlight):
		_reOrganize(true, cardNumber)
	else:
		_reOrganize(false, cardNumber)
	
#TODO FIXME when fastly swapping between cards this does not work properly
func _reOrganize(var highlight, var highlightedcard):
	for handCard in get_tree().get_nodes_in_group("cards"):
		var angle = -PI/2 + CardSpread*(float(NumberCardsHand - 1)/2 - handCard.number)
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
		handCard.rotation = (90+rad2deg(angle))/60
