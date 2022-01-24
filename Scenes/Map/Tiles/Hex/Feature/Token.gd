extends Node2D

var color
var creature
var damage = 0.0
var attacks
var health
var currentBlock
var lane
var active = true
var revealed = false

func _save():
	var save_dict = {}
	save_dict["Active"] = active
	save_dict["revealed"] = revealed
	return save_dict
	
func _load(var save_dict):
	if !save_dict["Active"]:
		_removeToken()
	elif save_dict["revealed"]:
		_reveal()

func _createToken(var tokenColor):
	StateController.boardTokens.append({"Position": global_position, "Revealed" : false, "Token" : self})
	color = tokenColor
	$TokenBG.texture = Assets._Token(color, "Background.png")
	$TokenFG.texture = Assets._Token(color, "Hold.png")
	
func _getCreatureAttributes():
	attacks = creature["Attack"]
	for attack in attacks:
		attack["Block"] = 0

func _setToken():
	if color == "Grey":
		var index = randi() % GameVariables.greyTokens.size()
		var creatureName = GameVariables.greyTokens[index]
		GameVariables.countrySideTileList.remove(index)
		creature = GameVariables.tokensInfo[color][creatureName]

func _reveal():
	_setToken()
	if color == "Grey":
		$TokenFG.texture = Assets._Token(color , creature["Image"])
		_getCreatureAttributes()
		revealed = true

func _addDamage(var damageValue, var damageType):
	if(creature["Resistances"].has(damageType)):
		damage += damageValue/2.0
	elif(creature["Resistances"].has("ColdFire") && (damageType == "Fire" || damageType == "Cold")):
		damage += damageValue/2.0
	else:
		damage += damageValue
	var text = TextBuilder._attackPhaseInfo(creature["Armor"] - damage)
	lane._setText(text)
 

func _addBlock(var blockValue, var _blockType):
	currentBlock = blockValue
	
	TurnManager.optionsPopup.clear()
	var id = 0
	for attack in attacks:
		TurnManager.optionsPopup.add_item(str(attack["Value"]),id)
		id += 1
	
	TurnManager.optionsPopup.popup()
	TurnManager.optionsPopup.connect("id_pressed",self,"_handleAction")
	TurnManager.optionsPopup.connect("popup_hide",self,"_disconnectPopUp")

func _handleAction(var id):
	TurnManager.optionsPopup.clear()
	TurnManager.optionsPopup.hide()
	var attack = attacks[id]
	attack["Block"] += currentBlock
	var blockText = TextBuilder._blockPhaseInfo(attacks)
	lane._setText(blockText)


func _disconnectPopUp():
	TurnManager.optionsPopup.disconnect("id_pressed",self,"_handleAction")
	TurnManager.optionsPopup.disconnect("popup_hide",self,"_disconnectPopUp")

func _kill():
	StateController.player1._gainFame(creature["Fame"])
	_removeToken()

func _removeToken():
	self.visible = false
	active = false
