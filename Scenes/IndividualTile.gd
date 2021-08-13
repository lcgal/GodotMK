extends CollisionPolygon2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var mouse_entered := false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_mouse_entered() -> void:
	mouse_entered = true

func _on_mouse_exited() -> void:
	mouse_entered = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
