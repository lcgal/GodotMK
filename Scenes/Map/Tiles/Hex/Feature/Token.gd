extends Node2D

var color

var creature

func _setToken(var tokenColor):
	GameVariables.boardTokens.append({"Position": global_position, "Revealed" : false, "Token" : self})
	color = tokenColor
	$TokenBG.texture = Assets._Token(color, "Background.png")
	$TokenFG.texture = Assets._Token(color, "Hold.png")

func _reveal():
	if color == "Grey":
		var index = randi() % GameVariables.greyTokens.size()
		var creatureName = GameVariables.greyTokens[index]
		GameVariables.countrySideTileList.remove(index)
		creature = GameVariables.tokensInfo[color][creatureName]
		$TokenFG.texture = Assets._Token(color , creature["Image"])
