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

func _on_Card_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton && event.button_index == BUTTON_LEFT && event.pressed && !played:
		$Outline.visible = true
		GameVariables.playCardPopup.clear()
		var id = 0
		if (TurnManager.turnPhase == Constants.TurnPhase.MOVEMENT):
			if (effects != null && effects["Basic"]["Types"].has("Move")):
				GameVariables.playCardPopup.add_item(effects["Basic"]["Types"]["Move"]["Text"],id)
				actions[id] = effects["Basic"]["Types"]["Move"]
				id += 1
				
			GameVariables.playCardPopup.add_item("Play sideways to add 1 movement")
			actions[id] = Constants.sidewayMove
			id += 1
			GameVariables.playCardPopup.popup()
			GameVariables.playCardPopup.connect("id_pressed",self,"_handleAction")
			GameVariables.playCardPopup.connect("popup_hide",self,"_disconnectPopUp")
			

func _handleAction(var id):
	GameVariables.playCardPopup.clear()
	_setAsPlayStatus(true)
	var effectType = actions[id]["Effect"]
	if effectType == "AddMove":
		GameVariables.player1.move(actions[id]["Value"])
		GameVariables.playCardPopup.disconnect("id_pressed",self,"_handleAction")

func _disconnectPopUp():
	$Outline.visible = false
	GameVariables.playCardPopup.disconnect("id_pressed",self,"_handleAction")
	GameVariables.playCardPopup.disconnect("about_to_show",self,"_disconnectPopUp")
