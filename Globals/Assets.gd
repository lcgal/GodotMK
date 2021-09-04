extends Node

var root = "res://Assets/"
var pathMapTiles = "MapTiles/Tiles/"
var pathCards = "Cards/Basic/"

func _mapTile(var tile):
	return load(root + pathMapTiles + tile)

func _card(var card):
	return load(root + pathCards + card)
