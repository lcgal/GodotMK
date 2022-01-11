extends Area2D
class_name Card

var number
signal highlight(highlight, number)
var effects

var actions = {}

var played = false
var locked = false

func _ready():
	pass

func _setSprite(var sprite):
	var spriteNode : Sprite = $Sprite
	spriteNode.texture = sprite


func _on_Card_mouse_entered():
	emit_signal("highlight", true, number)


func _on_Card_mouse_exited():
	emit_signal("highlight", false, number)

func _setAsPlayStatus(var boolean):
	played = boolean
	if boolean:
		modulate.a = 0.2
	else:
		modulate.a = 1

func _on_Card_input_event(var viewport, var event, var shape_idx):
	if event is InputEventMouseButton && event.button_index == BUTTON_LEFT && event.pressed && !played:
		$Outline.visible = true
		_showEffectOptions()


func _showEffectOptions():
	TurnManager.optionsPopup.hide()
	TurnManager.optionsPopup.clear()
	var id = 0
	for effect in Constants.RelevantEffects[TurnManager.turnPhase]:
		if (effects != null && effects["Basic"]["Types"].has(effect)):
			TurnManager.optionsPopup.add_item(effects["Basic"]["Types"][effect]["Text"],id)
			actions[id] = effects["Basic"]["Types"][effect]
			id += 1
		if effect in Constants.sidewayEffects:
			actions[id] = Constants.sidewayEffects[effect]
			TurnManager.optionsPopup.add_item(actions[id]["Text"])
			id += 1
			
	TurnManager.optionsPopup.popup()
	TurnManager.optionsPopup.connect("id_pressed",self,"_handleAction")
	TurnManager.optionsPopup.connect("popup_hide",self,"_disconnectPopUp")
	

func _handleAction(var id):
	TurnManager.optionsPopup.clear()
	TurnManager.optionsPopup.hide()
	_setAsPlayStatus(true)
	var effectType = actions[id]["Effect"]
	if effectType == "AddMove":
		GameVariables.player1.move(actions[id]["Value"])
	elif effectType == "AddAttack":
		TurnManager.combatLane._addDamage(actions[id]["Value"],actions[id]["Type"])
	elif effectType == "AddRanged":
		TurnManager.combatLane._addDamage(actions[id]["Value"],actions[id]["Type"])
	elif effectType == "AddBlock":
		TurnManager.combatLane._addBlock(actions[id]["Value"],actions[id]["Type"])

func _disconnectPopUp():
	$Outline.visible = false
	TurnManager.optionsPopup.disconnect("id_pressed",self,"_handleAction")
	TurnManager.optionsPopup.disconnect("popup_hide",self,"_disconnectPopUp")
