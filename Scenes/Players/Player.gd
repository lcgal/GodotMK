extends Node2D
var knight

var deck
var discard = []

func _draw():
	randomize()
	var index = randi() % deck.size()
	var card = deck[index]
	deck.remove(index)
	discard.append(card)
	return card


