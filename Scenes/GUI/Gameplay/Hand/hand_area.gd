extends Control
var origin = Vector2(-560,1317)

onready var center_card_oval = GameVariables.DefaultResolution * Vector2(0, 0.95)
onready var hor_rad = GameVariables.DefaultResolution.x*1
onready var ver_rad = GameVariables.DefaultResolution.y*0.8
var card_size
var card_spread
var normal_scale = Vector2(0.4,0.4)
var highlight_scale = Vector2(0.6,0.6)


func _ready():
	StateController.hand_area = self

func reset_actions():
	for hand_card in get_tree().get_nodes_in_group("cards"):
		if !hand_card.locked:
			hand_card.set_played_status(false)

func add_card(var card):
	card.number = StateController.player1.hand_size
	card.scale = normal_scale
	if card_size == null:
		card_size = card.get_node("Sprite").texture.get_size()
	if card_spread == null:
		card_spread = 0.0004*card_size.x
	add_child(card)
	card.add_to_group("cards")
	card.connect("highlight",self,"handle_highlight")
	
	_reorganize(false, null)


func handle_highlight(var highlight, card_number):
	if (highlight):
		_reorganize(true, card_number)
	else:
		_reorganize(false, card_number)
	
#TODO FIXME when fastly swapping between cards this does not work properly
func _reorganize(var highlight, var highlighted_card):
	var i = 0
	for hand_card in get_tree().get_nodes_in_group("cards"):
		hand_card.number = i
		i += 1
		var angle = -PI/2 + card_spread*(float(StateController.player1.hand_size - 1)/2 - hand_card.number)
		if (highlight && hand_card.number > highlighted_card):
			angle -= card_spread*0.8
		elif (highlight && hand_card.number < highlighted_card):
			angle += card_spread*0.8
		elif (highlighted_card != null && hand_card.number == highlighted_card):
			if (highlight):
				hand_card.scale = highlight_scale
			else:
				hand_card.scale = normal_scale
		
		var oval_angle_vector = Vector2(hor_rad * cos(angle),ver_rad * sin(angle))
		var pos = center_card_oval + oval_angle_vector - Vector2(card_size.x/2,card_size.y)
		hand_card.position = pos
		hand_card.rotation = (90+rad2deg(angle))/90

func lock_played_cards():
	for hand_card in get_tree().get_nodes_in_group("cards"):
		if hand_card.played:
			hand_card.locked = true

func discard_cards():
	for hand_card in get_tree().get_nodes_in_group("cards"):
		if hand_card.played:
			StateController.player1.hand.erase(hand_card.name)
			hand_card.queue_free()
			StateController.player1.hand_size -= 1
	_reorganize(false, null)
