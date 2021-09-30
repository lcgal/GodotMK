extends Camera2D

class_name MainCamera

var _previousPosition: Vector2 = Vector2(0, 0);
var _moveCamera: bool = false;
var minZoom = Vector2(1,1)

func _ready():
	zoom = Vector2(2,2)

func _unhandled_input(event: InputEvent):
	if event is InputEventMouseButton && event.button_index == BUTTON_MIDDLE:
		get_tree().set_input_as_handled();
		if event.is_pressed():
			_previousPosition = event.position;
			_moveCamera = true;
		else:
			_moveCamera = false;
	elif event is InputEventMouseMotion && _moveCamera:
		get_tree().set_input_as_handled();
		position += (_previousPosition - event.position)*zoom[1];
		_previousPosition = event.position;
	
	elif event is InputEventMouseButton && event.button_index == BUTTON_WHEEL_UP:
		if (zoom > minZoom):
			zoom -= Vector2(.2,.2)
	elif event is InputEventMouseButton && event.button_index == BUTTON_WHEEL_DOWN:
		zoom += Vector2(.2,.2)
