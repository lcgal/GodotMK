extends Camera2D

class_name MainCamera

var _previous_position: Vector2 = Vector2(0, 0);
var _move_camera: bool = false;
var _min_zoom = Vector2(1,1)

func _ready():
	zoom = Vector2(2,2)

func _unhandled_input(event: InputEvent):
	if event is InputEventMouseButton && event.button_index == BUTTON_MIDDLE:
		get_tree().set_input_as_handled();
		if event.is_pressed():
			_previous_position = event.position;
			_move_camera = true;
		else:
			_move_camera = false;
	elif event is InputEventMouseMotion && _move_camera:
		get_tree().set_input_as_handled();
		position += (_previous_position - event.position)*zoom[1];
		_previous_position = event.position;
	
	elif event is InputEventMouseButton && event.button_index == BUTTON_WHEEL_UP:
		if (zoom > _min_zoom):
			zoom -= Vector2(.2,.2)
	elif event is InputEventMouseButton && event.button_index == BUTTON_WHEEL_DOWN:
		zoom += Vector2(.2,.2)
