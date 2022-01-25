extends Node2D

var type
var tokens = []
var hexToken
var featureInfo

func _setFeature(var info):
	featureInfo = info
	if featureInfo != null && featureInfo["Token"] != null:
		SceneInitializer._initializeToken(featureInfo, self)

func _moveInto():
	if featureInfo != null:
		if featureInfo["AutoCombat"]:
			_startCombat()

func _startCombat():
	if hexToken != null:
		remove_child(hexToken)
		TurnManager._startCombat(hexToken)

func _save():
	var save_dict = {}
	if hexToken != null:
		save_dict = hexToken._save()
		return save_dict

func _load(var savedFeatureInfo):
	if hexToken != null:
		hexToken._load(savedFeatureInfo)
