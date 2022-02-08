extends Node2D

var color
var creature
var damage = 0.0
var attacks
var health
var current_block
var lane
var active = true
var revealed = false

func save_game():
	var save_dict = {}
	save_dict["Active"] = active
	save_dict["revealed"] = revealed
	return save_dict
	
func load_game(var save_dict):
	if !save_dict["Active"]:
		_remove_token()
	elif save_dict["revealed"]:
		_reveal()

func create_token(var tokenColor):
	StateController.board_tokens.append({"Position": global_position, "Revealed" : false, "Token" : self})
	color = tokenColor
	$TokenBG.texture = Assets.token(color, "Background.png")
	$TokenFG.texture = Assets.token(color, "Hold.png")
	
func get_creature_attributes():
	attacks = creature["Attack"]
	for attack in attacks:
		attack["Block"] = 0

func _set_token():
	var index = randi() % GameVariables.available_tokens[color].size()
	var creature_name = GameVariables.available_tokens[color][index]
	GameVariables.available_tokens[color].remove(index)
	creature = GameVariables.tokens_info[color][creature_name]

func _reveal():
	_set_token()
	if color == "Grey":
		$TokenFG.texture = Assets.token(color , creature["Image"])
		get_creature_attributes()
		revealed = true

func add_damage(var damage_value, var damage_type):
	if(creature["Resistances"].has(damage_type)):
		damage += damage_value/2.0
	elif(creature["Resistances"].has("ColdFire") && (damage_type == "Fire" || damage_type == "Cold")):
		damage += damage_value/2.0
	else:
		damage += damage_value
	var text = TextBuilder.attack_phase_info(creature["Armor"] - damage)
	lane.set_text(text)
 

func add_block(var block_value , var _block_type):
	current_block = block_value
	
	TurnManager.options_popup.clear()
	var id = 0
	for attack in attacks:
		TurnManager.options_popup.add_item(str(attack["Value"]),id)
		id += 1
	
	TurnManager.options_popup.popup()
	TurnManager.options_popup.connect("id_pressed",self,"handled_action")
	TurnManager.options_popup.connect("popup_hide",self,"disconnect_popup")

func handled_action(var id):
	TurnManager.options_popup.clear()
	TurnManager.options_popup.hide()
	var attack = attacks[id]
	attack["Block"] += current_block
	var blockText = TextBuilder.block_phase_info(attacks)
	lane.set_text(blockText)


func disconnect_popup():
	TurnManager.options_popup.disconnect("id_pressed",self,"handled_action")
	TurnManager.options_popup.disconnect("popup_hide",self,"disconnect_popup")

func _kill():
	StateController.player1._gainFame(creature["Fame"])
	_remove_token()

func _remove_token():
	self.visible = false
	active = false
