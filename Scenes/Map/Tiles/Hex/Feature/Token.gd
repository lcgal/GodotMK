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
var in_combat = false
var token_name

func save_game():
	var save_dict = {}
	save_dict["active"] = active
	save_dict["revealed"] = revealed
	save_dict["color"] = color
	save_dict["token_name"] = token_name

	return save_dict
	


func create_token(var tokenColor, var saved_info):
	color = tokenColor
	$TokenBG.texture = Assets.token(color, "Background.png")
	$TokenFG.texture = Assets.token(color, "Foreground.png")
	
	if saved_info == null:
		_draw_token()
	else:
		_set_token(saved_info)
		
	
	_get_creature_attributes()


func _draw_token():
	var index = randi() % GameVariables.available_tokens[color].size()
	token_name = GameVariables.available_tokens[color][index]
	GameVariables.available_tokens[color].remove(index)
	creature = GameVariables.tokens_info[color][token_name]
	


func _set_token(var saved_info):
	token_name = saved_info["token_name"]
	creature = GameVariables.tokens_info[color][token_name]
	_set_token_status(saved_info)
	

func _set_token_status(var save_dict):
	if save_dict["revealed"]:
		_reveal()


func _get_creature_attributes():
	attacks = creature["Attack"]
	for attack in attacks:
		if attack["type"] == "SummonerBrown":
			pass
		attack["Block"] = 0


func _reveal():
	$TokenFG.texture = Assets.token(color , creature["Image"])
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

func kill():
	StateController.player1._gainFame(creature["Fame"])
	_remove_token()

func _remove_token():
	self.visible = false
	active = false
