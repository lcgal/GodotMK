extends Area2D

var key
signal movement(pos,key)
var feature

func _on_Hex_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton && event.button_index == BUTTON_LEFT && event.pressed:
		if feature == null:
			emit_signal("movement",global_position,key)
		else:
			emit_signal("movement",global_position,key)
			feature._moveInto()


func _set_Feature(var featureType):
	if featureType in Constants.features:
		var featureInfo = Constants.features[featureType]
		if featureInfo != null:
			SceneInitializer._initializeFeature(featureInfo, self)

func _save():
	if feature != null:
		return feature._save()
	
func _load(var savedFeatureInfo):
	feature._load(savedFeatureInfo)
