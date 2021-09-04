extends Node

var rootJsons = "res://ConfigJsons/"
var pathKnights = "Knights/"
var pathCards = "Cards/"

func _loadKnight(var knight):
	if knight == Constants.Knights.TOVAK:
		var file = File.new()
		file.open(rootJsons + pathKnights + "Tovak.json",file.READ)
		var knightJson = file.get_as_text()
		file.close()
		return JSON.parse(knightJson).result
		
func _loadMap(var map):
	if map == Constants.Maps.WEDGE:
		var file = File.new()
		file.open(rootJsons + "WedgeMapTiles.json",file.READ)
		var tileJson = file.get_as_text()
		file.close()
		return JSON.parse(tileJson).result

func _loadCardsActions():
	var file = File.new()
	file.open(rootJsons + pathCards + "Actions.json",file.READ)
	var cardsJson = file.get_as_text()
	file.close()
	return JSON.parse(cardsJson).result
