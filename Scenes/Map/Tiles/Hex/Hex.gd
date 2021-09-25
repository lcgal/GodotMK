extends Area2D

var key
signal movement(pos,key)
var tileFeature
var feature

func _ready():
	pass # Replace with function body.

func _on_Hex_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton && event.button_index == BUTTON_LEFT && event.pressed:
		if tileFeature == null:
			emit_signal("movement",global_position,key)
		elif tileFeature["Type"] == "Hold" && tileFeature["Owner"] == null:
			emit_signal("movement",global_position,key)
			TurnManager._startCombat()
		else:
			emit_signal("movement",global_position,key)

func _set_Feature(var feature):
	if feature != null:
		tileFeature = {"Type" : feature, "Owner" : null}
		
		var featureSceneInstance = load("res://Scenes/Map/Tiles/Hex/Token/Token.tscn").instance()
		add_child(featureSceneInstance)
		featureSceneInstance._setToken(feature)
		feature = featureSceneInstance

