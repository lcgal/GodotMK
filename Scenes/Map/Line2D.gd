extends Line2D


func _ready():
	pass


func _on_Area2D_mouse_entered():
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
