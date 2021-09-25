extends Node

var root = "res://Assets/"
var pathMapTiles = "MapTiles/Tiles/"
var pathCards = "Cards/Basic/"


var pathGrey = "Tokens/Grey/"



func _mapTile(var tile):
	return load(root + pathMapTiles + tile)

func _card(var card):
	return load(root + pathCards + card)

func _Token(var type, var name):
	if type == "Grey":
		return load(root + pathGrey + name)
