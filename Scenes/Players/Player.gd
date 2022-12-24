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
var turn_movements = []

var green_crystals = 0
var red_crystals = 0
var blue_crystals = 0
var white_crystals = 0
var gold_crystals = 0
var dark_crystals = 0

var influence = 0

var reputation = 0

signal update_deck_count(count)
signal update_crystal_count(color, count)

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
	"turn_movements",
	"influence",
	"reputation",
	"green_crystals",
	"red_crystals",
	"blue_crystals",
	"white_crystals",
	"gold_crystals",
	"dark_crystals",
]

func _ready():
	var deck_GUI = get_tree().get_root().get_node("/root/Game/CanvasLayer/Control/Deck")
	deck_GUI._connect(self)
	var crystals_GUI = get_tree().get_root().get_node("/root/Game/CanvasLayer/Control/CrystalsInfo")
	crystals_GUI._connect(self)
	hand_GUI = StateController.hand_area
	hand_GUI.connect("discard_card", self, "remove_card")
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


func start_turn():
	turn_movements = []
	draw_to_hand_limit()

func draw_to_hand_limit():
	while hand_size < handLimit:
		_drawCard()

func draw_cards(var qtd):
	for _i in range (0, qtd, 1):
		_drawCard()
		
func reset_actions():
	movement_points = 0
	TurnManager.update_movement_points(movement_points)
	hand_GUI.reset_actions()

func add_move(var movePoints):
	movement_points += movePoints
	TurnManager.update_movement_points(movement_points)

func move(var target_pos):
	turn_movements.append(position)
	position = target_pos

func move_back():
	position = Converter.string_to_vector2(turn_movements.pop_back())

func add_influence(var influencePoints):
	influence += influencePoints

func add_reputation(var reputationPoints):
	reputation += reputationPoints

func draw_blood(var qtd):
	for _i in range(0, qtd, 1):
		SceneInitializer.blood()
		hand.append("Blood")
		hand_size += 1

func heal_hand(var qtd):
	for _i in range (0, qtd, 1):
		hand_GUI.discard_blood()

func _gainFame(var value):
	experience += value
	var experience_text = TextBuilder.experience_label_text(experience) 
	
	StateController.player_panel.set_experience_text(experience_text)

func clean_movement():
	movement_points = 0
	TurnManager.update_movement_points(movement_points)

func clean_influence():
	influence = 0

func lock_cards():
	hand_GUI.lock_played_cards()


func discard_cards():
	hand_GUI.discard_cards()

func remove_card(var card_name):
	hand.erase(card_name)
	discard.append(card_name)

func crystal(var color, var qtd):
	if color == "green":
		green_crystals += qtd
		emit_signal("update_crystal_count",color,green_crystals)
	elif color == "red":
		red_crystals += qtd
		emit_signal("update_crystal_count",color,red_crystals)
	elif color == "blue":
		blue_crystals += qtd
		emit_signal("update_crystal_count",color,blue_crystals)
	elif color == "white":
		white_crystals += qtd
		emit_signal("update_crystal_count",color,white_crystals)
	elif color == "gold":
		gold_crystals += qtd
		emit_signal("update_crystal_count",color,gold_crystals)
	elif color == "dark":
		dark_crystals += qtd
		emit_signal("update_crystal_count",color,dark_crystals)
	elif color == "Any":
		blue_crystals += qtd
		emit_signal("update_crystal_count","blue",blue_crystals)
	
	
func quit_game():
	queue_free()
