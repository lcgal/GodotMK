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
				for action in effects["Basic"]["Types"][effect]:
					TurnManager.options_popup.add_item(action["Text"],id)
					actions[id] = action["Effect"]
					id += 1
			if (effects["Advanced"] != null && effects["Advanced"]["Types"].has(effect)):
				for action in effects["Advanced"]["Types"][effect]:
					TurnManager.options_popup.add_item(action["Text"],id)
					actions[id] = action["Effect"]
					id += 1
			if effect in Constants.sideway_effects:
				TurnManager.options_popup.add_item(Constants.sideway_effects[effect]["Text"])
				actions[id] = Constants.sideway_effects[effect]["Effect"]
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
	for action in actions[id]:
		Actions.play_effect(action)


func disconnect_popup():
	$Outline.visible = false
	TurnManager.options_popup.disconnect("id_pressed",self,"handled_action")
	TurnManager.options_popup.disconnect("popup_hide",self,"disconnect_popup")
