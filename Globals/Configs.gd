extends Node

var rootJsons = "res://ConfigJsons/"
var pathKnights = "Knights/"
var pathCards = "Cards/"

func _readJson(var json):
	var file = File.new()
	file.open(json,file.READ)
	var jsonInfo = file.get_as_text()
	file.close()
	return JSON.parse(jsonInfo).result

func _loadKnight(var knight):
	if knight == Constants.Knights.TOVAK:
		return _readJson(rootJsons + pathKnights + "Tovak.json")

func _loadMap(var map):
	if map == Constants.Maps.WEDGE:
		return _readJson(rootJsons + "WedgeMapTiles.json")

func _loadCardsActions():
	return _readJson(rootJsons + pathCards + "Actions.json")

func _loadTilesInfo():
	return _readJson(rootJsons +"MapTiles.json")

func _loadMovementInfo():
	return _readJson(rootJsons + "MovementCosts.json")

