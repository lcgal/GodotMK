extends Node

func block_phase_info(var attacks):
	var text = ""
	for attack in attacks:
		var unblocked = attack["Value"] - attack["Block"]
		if unblocked > 0:
			text += "unblocked attack: [color=#FF1B00]" + str(unblocked) + "[/color]\n"
		else:
			text += "[color=#00FF00] attack blocked [/color]" + "\n"
	return text


func attack_phase_info(var health_left):
	if health_left > 0:
		return "Health left: [color=#FF1B00]" + str(health_left)
	else:
		return "Health left: [color=#00FF00]" + str(health_left)

func experience_label_text(var experience):
	return "Experience : " + str(experience)

func turn_text(var turn):
	return "Turn: " + str(turn)
