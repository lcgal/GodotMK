extends Line2D

var active = false

func _ready():
	pass


func _on_Area2D_mouse_entered():
	if (active):
		visible = true


func _on_Area2D_mouse_exited():
	visible = false


func _on_ExplorableTile_activate():
	active = true
