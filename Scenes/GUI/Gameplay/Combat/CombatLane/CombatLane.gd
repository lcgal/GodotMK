extends Area2D

var token

func _ready():
	TurnManager.combatLane = self

func _addToken(var creatureToken):
	token = creatureToken
	$TokenZone._addToken(token)

func _addAtack(var attackValue, var attackType):
	var healthLeft = token._addDamage(attackValue, attackType)
	
