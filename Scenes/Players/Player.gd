extends Node2D
var knight

var hand_GUI

var deck
var hand = []
var discard = []
var hand_size = 0
var handLimit = 5
var armor = 2
var experience = 0

var movement_points = 0

signal update_deck_count(count)

var savable_attr = [
	"knight",
	"deck",
	"hand",
	"discard",
	"hand_size",
	"handLimit",
	"armor",
	"experience",
	"movement_points",
]

func _ready():
	var deck_GUI = get_tree().get_root().get_node("/root/Game/CanvasLayer/Control/Deck")
	deck_GUI._connect(self)
	hand_GUI = StateController.hand_area
	emit_signal("update_deck_count",deck.size())


func save_game():
	var save_dict = {}
	for key in savable_attr:
		save_dict[key] = get(key)
	
	save_dict["position"] = position
	
	return save_dict

func load_game(var load_dict):
	for key in savable_attr:
		set(key, load_dict[key])
	
	for card in hand:
		SceneInitializer.card(card)
		
	position = Converter.string_to_vector2(load_dict["position"])
	emit_signal("update_deck_count",deck.size())


func _drawCard():
	randomize()
	var index = randi() % deck.size()
	var card = deck[index]
	deck.remove(index)
	hand.append(card)
	emit_signal("update_deck_count",deck.size())
	SceneInitializer.card(card)
	hand_size += 1

func draw_to_hand_limit():
	while hand_size < handLimit:
		_drawCard()

func reset_actions():
	movement_points = 0
	TurnManager.update_movement_points(movement_points)
	hand_GUI.reset_actions()

func move(var movePoints):
	movement_points += movePoints
	TurnManager.update_movement_points(movement_points)
	
func draw_blood(var qtd):
	for _i in range(0, qtd, 1):
		SceneInitializer.blood()
		hand.append("Blood")
		hand_size += 1

func _gainFame(var value):
	experience += value
	var experience_text = TextBuilder.experience_label_text(experience) 
	
	StateController.player_panel.set_experience_text(experience_text)


func lock_cards():
	hand_GUI.lock_played_cards()


func discard_cards():
	hand_GUI.discard_cards()


func quit_game():
	queue_free()
