extends Node2D

var type
var tokens = []
var hexToken

func _setFeature(var featureType):
	if featureType == "Hold":
		type = featureType
		var tokenSceneInstance = load("res://Scenes/Map/Tiles/Hex/Feature/Token.tscn").instance()
		add_child(tokenSceneInstance)
		tokenSceneInstance._setToken("Grey")
		tokenSceneInstance.set_name("token")
		hexToken = get_node("token")
		tokens.append(hexToken)


func _startCombat():
	if hexToken != null:
		remove_child(hexToken)
	TurnManager._startCombat(tokens)
