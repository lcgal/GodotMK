extends Area2D

var token

func _ready():
	TurnManager.combatLane = self

func _addToken(var creatureToken):
	token = creatureToken
	token.lane = self
	$TokenZone._addToken(token)
	#$Label.bbcode_text = "Health left: [color=#FF1B00]" + str(token.creature["Armor"])

func _addDamage(var attackValue, var attackType):
	token._addDamage(attackValue, attackType)

func _setText(var text):
	$Label.bbcode_text =  text

func _addBlock(var attackValue, var attackType):
	token._addBlock(attackValue, attackType)

func _endCombatPhase(var phase):
	match phase:
		Constants.TurnPhase.COMBAT_BLOCK_PHASE:
			for attack in token.creature["Attack"]:
				if attack["Block"] < attack["Value"]:
					var armor = GameVariables.player1.armor
					var damage = ceil(attack["Value"]/armor)
					GameVariables.player1._drawBlood(damage)
					
		Constants.TurnPhase.COMBAT_RANGED_PHASE, Constants.TurnPhase.COMBAT_MELEE_PHASE:
			if token.creature["Armor"] - token.damage <= 0:
				token._kill()
	
