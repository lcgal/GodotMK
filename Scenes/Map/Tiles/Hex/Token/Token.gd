extends Node2D

var tokenType

func _setToken(var type):
	GameVariables.hexFeatures.append({"Position": global_position, "Revealed" : false, "Hex" : self})
	tokenType = type
	if type == "Hold":
		$TokenBG.texture = Assets._Token("Grey", "Background.png")
		$TokenFG.texture = Assets._Token("Grey", "Hold.png")
		

func _revealFeature():
	if tokenType == "Hold":
		$TokenFG.texture = Assets._Token("Grey", "HeroesGreen.png")
