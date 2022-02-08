extends Area2D

func add_token(var token):
	$TokenArea.add_child(token)
	token.global_position = $TokenArea.global_position
