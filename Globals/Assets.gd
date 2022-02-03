extends Node

const ROOT = "res://Assets/"
const MAP_TILES_PATH = ROOT + "MapTiles/Tiles/"
const CARDS_PATH = ROOT + "Cards/"
const BASIC_CARDS_PATH = ROOT + "Cards/Basic/"

const TOKENS_PATH = ROOT + "Tokens/"

func map_tile(var tile):
	return load(MAP_TILES_PATH + tile)

func card(var card):
	# TODO use a single directory for all cards
	return load(BASIC_CARDS_PATH + card)

func blood():
	return load(CARDS_PATH + "Blood.png")

func token(var type, var name):
	return load(TOKENS_PATH + type + "/" + name)
