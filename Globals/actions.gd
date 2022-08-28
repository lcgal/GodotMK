extends Node

# script responsible to handle all card and skills actions.

var card_actions = {
	"AddAttack" : funcref(self,"add_attack"),
	"AddMove" : funcref(self,"add_move"),
	"AddRanged" : funcref(self,"add_ranged_attack"),
	"AddBlock" : funcref(self,"add_block"),
	"Heal" : funcref(self,"heal"),
	"Draw" : funcref(self,"draw"),
	"AddInfluence" : funcref(self,"add_influence"),
	"AddReputation" : funcref(self,"add_reputation"),
	"GainCrystal" : funcref(self,"gain_crystal"),
	"PayMana" : funcref(self,"pay_mana"),
	"GainManaToken" : funcref(self,"gain_mana_token"),
	"SetSourceDie" : funcref(self,"set_source_die"),
#	"PlayCard" : funcref(self,"play_card"),
#	"AddInfluence" : funcref(self,"add_influence"),
#	"AddInfluence" : funcref(self,"add_influence"),
#	"AddInfluence" : funcref(self,"add_influence"),
#	"AddInfluence" : funcref(self,"add_influence"),
#	"AddInfluence" : funcref(self,"add_influence"),
#	"AddInfluence" : funcref(self,"add_influence"),
#	"AddInfluence" : funcref(self,"add_influence"),
#	"AddInfluence" : funcref(self,"add_influence"),
#	"AddInfluence" : funcref(self,"add_influence"),
#	"AddInfluence" : funcref(self,"add_influence"),
}


func play_effect(var action):
	card_actions[action["Action"]].call_func(action)
	
	
func add_attack(var action):
	var value = action["Value"]
	var type = action["Type"]
	TurnManager.combat_lane.add_damage(value,type)


func add_move(var action):
	var value = action["Value"]
	StateController.player1.add_move(value)


func add_ranged_attack(var action):
	var value = action["Value"]
	var type = action["Type"]
	TurnManager.combat_lane.add_damage(value,type)


func add_block(var action):
	var value = action["Value"]
	var type = action["Type"]
	TurnManager.combat_lane.add_block(value,type)


func heal(var action):
	var value = action["Value"]
	StateController.player1.heal_hand(value)


func draw(var action):
	var value = action["Value"]
	StateController.player1.draw_cards(value)
	pass


func add_influence(var action):
	var value = action["Value"]
	StateController.player1.add_influence(value)


func add_reputation(var action):
	var value = action["Value"]
	StateController.player1.add_reputation(value)


func gain_crystal(var action):
	pass


func pay_mana(var action):
	pass


func gain_mana_token(var action):
	pass


func play_card(var action):
	pass


