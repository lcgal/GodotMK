extends Node

func _string_to_vector2(var vector) -> Vector2:
	if vector is String:
		var new_string: String = vector
		new_string.erase(0, 1)
		new_string.erase(new_string.length() - 1, 1)
		var array: Array = new_string.split(", ")

		return Vector2(array[0], array[1])

	return vector
