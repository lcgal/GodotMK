extends Node2D

var color
var creature
var damage = 0.0
var attacks
var health
var currentBlock
var lane
var active

func _setToken(var tokenColor):
	GameVariables.boardTokens.append({"Position": global_position, "Revealed" : false, "Token" : self})
	color = tokenColor
	$TokenBG.texture = Assets._Token(color, "Background.png")
	$TokenFG.texture = Assets._Token(color, "Hold.png")
	
func _getCreatureAttributes():
	attacks = creature["Attack"]
	for attack in attacks:
		attack["Block"] = 0

func _reveal():
	if color == "Grey":
		var index = randi() % GameVariables.greyTokens.size()
		var creatureName = GameVariables.greyTokens[index]
		GameVariables.countrySideTileList.remove(index)
		creature = GameVariables.tokensInfo[color][creatureName]
		$TokenFG.texture = Assets._Token(color , creature["Image"])
		_getCreatureAttributes()
		active = true

func _addDamage(var damageValue, var damageType):
	if(creature["Resistances"].has(damageType)):
		damage += damageValue/2.0
	elif(creature["Resistances"].has("ColdFire") && (damageType == "Fire" || damageType == "Cold")):
		damage += damageValue/2.0
	else:
		damage += damageValue
	var text = TextBuilder._attackPhaseInfo(creature["Armor"] - damage)
	lane._setText(text)
 

func _addBlock(var blockValue, var blockType):
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
	GameVariables.player1._gainFame(creature["Fame"])
	self.visible = false
	active = false
