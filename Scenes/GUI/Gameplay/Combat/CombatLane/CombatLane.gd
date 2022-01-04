extends Area2D

var token

func _ready():
	TurnManager.combatLane = self

func _addToken(var creatureToken):
	token = creatureToken
	$TokenZone._addToken(token)
	$Label.bbcode_text = "Health left: [color=#FF1B00]" + str(token.creature["Armor"])

func _addAttack(var attackValue, var attackType):
	var healthLeft = token._addDamage(attackValue, attackType)
	if healthLeft > 0:
		$Label.bbcode_text = "Health left: [color=#FF1B00]" + str(healthLeft)
	else:
		$Label.bbcode_text = "Health left: [color=#00FF00]" + str(healthLeft)
