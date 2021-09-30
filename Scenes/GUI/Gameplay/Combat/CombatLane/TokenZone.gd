extends Area2D

func _addToken(var token):
	$TokenArea.add_child(token)
	token.global_position = $TokenArea.global_position
