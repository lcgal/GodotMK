extends Area2D
class_name Card

signal highlight(highlight, number)
var number
var effects

var actions = {}

var played = false
var locked = false

func _ready():
	pass

func set_sprite(var sprite):
	$Sprite.texture = sprite


func _on_Card_mouse_entered():
	emit_signal("highlight", true, number)


func _on_Card_mouse_exited():
	emit_signal("highlight", false, number)

func set_played_status(var boolean):
	played = boolean
	if boolean:
		modulate.a = 0.2
	else:
		modulate.a = 1

func _on_Card_input_event(var _viewport, var event, var _shape_idx):
	if event is InputEventMouseButton && event.button_index == BUTTON_LEFT && event.pressed && !played:
		_show_effects_options()


func _show_effects_options():
	TurnManager.options_popup.hide()
	TurnManager.options_popup.clear()
	
	var id = 0
	for effect in Constants.relevant_effects[TurnManager.turn_phase]:
		if effects != null:
			if (effects["Basic"] != null && effects["Basic"]["Types"].has(effect)):
				TurnManager.options_popup.add_item(effects["Basic"]["Types"][effect]["Text"],id)
				actions[id] = effects["Basic"]["Types"][effect]
				id += 1
			if (effects["Advanced"] != null && effects["Advanced"]["Types"].has(effect)):
				TurnManager.options_popup.add_item(effects["Advanced"]["Types"][effect]["Text"],id)
				actions[id] = effects["Advanced"]["Types"][effect]
				id += 1
		if effect in Constants.sideway_effects:
			actions[id] = Constants.sideway_effects[effect]
			TurnManager.options_popup.add_item(actions[id]["Text"])
			id += 1
	if id > 0:
		$Outline.visible = true
		TurnManager.options_popup.popup()
		TurnManager.options_popup.connect("id_pressed",self,"handled_action")
		TurnManager.options_popup.connect("popup_hide",self,"disconnect_popup")
	

func handled_action(var id):
	TurnManager.options_popup.clear()
	TurnManager.options_popup.hide()
	set_played_status(true)
	var effectType = actions[id]["Effect"]
	if effectType == "AddMove":
		StateController.player1.move(actions[id]["Value"])
	elif effectType == "AddAttack":
		TurnManager.combat_lane.add_damage(actions[id]["Value"],actions[id]["Type"])
	elif effectType == "AddRanged":
		TurnManager.combat_lane.add_damage(actions[id]["Value"],actions[id]["Type"])
	elif effectType == "AddBlock":
		TurnManager.combat_lane.add_block(actions[id]["Value"],actions[id]["Type"])

func disconnect_popup():
	$Outline.visible = false
	TurnManager.options_popup.disconnect("id_pressed",self,"handled_action")
	TurnManager.options_popup.disconnect("popup_hide",self,"disconnect_popup")
