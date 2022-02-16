extends Area2D

var token

func _ready():
	TurnManager.combat_lane = self


func save_game():
	return token.save_game()


func load_game(var _load_dict):
	pass


func add_token(var creatureToken):
	token = creatureToken
	token.lane = self
	$TokenZone.add_token(token)
	#$Label.bbcode_text = "Health left: [color=#FF1B00]" + str(token.creature["Armor"])

func add_damage(var attack_value, var attack_type):
	token.add_damage(attack_value, attack_type)

func set_text(var text):
	$Label.bbcode_text =  text

func add_block(var attack_value, var attack_type):
	token.add_block(attack_value, attack_type)

func end_combat_phase(var phase):
	match phase:
		Constants.turn_phase.COMBAT_BLOCK_PHASE:
			for attack in token.creature["Attack"]:
				if attack["Block"] < attack["Value"]:
					var armor = StateController.player1.armor
					var damage = ceil(attack["Value"]/armor)
					StateController.player1.draw_blood(damage)
					
		Constants.turn_phase.COMBAT_RANGED_PHASE, Constants.turn_phase.COMBAT_MELEE_PHASE:
			if token.creature["Armor"] - token.damage <= 0:
				token.kill()
				TurnManager.end_combat(true)
	

func failed_combat():
	$TokenZone.remove_token(token)
	return token
