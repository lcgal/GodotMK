extends Node

# script responsible to handle all card and skills actions.

var card_actions = {
	"AddAttack" : funcref(self,"add_attack"),
	"AddMove" : funcref(self,"add_move"),
	"AddRanged" : funcref(self,"add_ranged_attack"),
	"AddBlock" : funcref(self,"add_block"),
	"Heal" : funcref(self,"heal"),
}


func play_card(var action, var value, var type):
	card_actions[action].call_func(value, type)
	
	
func add_attack(var value, var type):
	TurnManager.combat_lane.add_damage(value,type)


func add_move(var value, var _type):
	StateController.player1.add_move(value)


func add_ranged_attack(var value, var type):
	TurnManager.combat_lane.add_damage(value,type)


func add_block(var value, var type):
	TurnManager.combat_lane.add_block(value,type)


func heal(var value, var type):
	pass
