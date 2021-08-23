extends Line2D

var active = false

func _ready():
	pass

func _on_Area2D_mouse_entered():
	if (active):
		visible = true


func _on_Area2D_mouse_exited():
	visible = false

#var defaultColor = Color(0.4,0.501961,1,1)
#var highlightColor = Color(0.807843,0.807843,0.819608,1)
#
#func _on_Area2D_mouse_entered():
#	default_color = highlightColor
#
#func _on_Area2D_mouse_exited():
#	default_color = defaultColor


func _on_ExplorableTile_activate():
	active = true
