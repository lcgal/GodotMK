extends Area2D

var key
signal movement(pos,key)
var featureInfo
var feature

func _ready():
	pass # Replace with function body.

func _on_Hex_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton && event.button_index == BUTTON_LEFT && event.pressed:
		if featureInfo == null:
			emit_signal("movement",global_position,key)
		elif featureInfo["Type"] == "Hold" && featureInfo["Owner"] == null:
			emit_signal("movement",global_position,key)
			feature._startCombat()
			
		else:
			emit_signal("movement",global_position,key)

func _set_Feature(var featureType):
	if featureType != null && featureType == "Hold":
		featureInfo = {"Type" : featureType, "Owner" : null}
		var featureSceneInstance = load("res://Scenes/Map/Tiles/Hex/Feature/Feature.tscn").instance()
		add_child(featureSceneInstance)
		featureSceneInstance._setFeature(featureType)
		featureSceneInstance.set_name("Feature")
		feature = get_node("Feature")
		
