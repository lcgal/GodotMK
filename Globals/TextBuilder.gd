extends Node

func _blockPhaseInfo(var attacks):
	var text = ""
	for attack in attacks:
		var unblocked = attack["Value"] - attack["Block"]
		if unblocked > 0:
			text += "unblocked attack: [color=#FF1B00]" + str(unblocked) + "[/color]\n"
		else:
			text += "[color=#00FF00] attack blocked [/color]" + "\n"
	return text


func _attackPhaseInfo(var healthLeft):
	if healthLeft > 0:
		return "Health left: [color=#FF1B00]" + str(healthLeft)
	else:
		return "Health left: [color=#00FF00]" + str(healthLeft)

func _experienceLabelText(var experience):
	return "Experience : " + str(experience)
