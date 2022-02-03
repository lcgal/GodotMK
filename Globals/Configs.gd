extends Node

var rootJsons = "res://ConfigJsons/"
var pathKnights = "Knights/"
var pathCards = "Cards/"
var savePath = "Saves/"

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
		var mapData = _readJson(rootJsons + "WedgeMapTiles.json")
		var tilesData = _loadTilesInfo()
		var movementData = _loadMovementInfo()
		GameVariables._InitializeMapData(mapData, tilesData, movementData)
		
func _loadCardsActions():
	return _readJson(rootJsons + pathCards + "Actions.json")

func _loadTilesInfo():
	return _readJson(rootJsons +"MapTiles.json")

func _loadMovementInfo():
	return _readJson(rootJsons + "MovementCosts.json")

func _loadTokensInfo():
	var tokens = _readJson(rootJsons + "Tokens.json")
	GameVariables.tokensInfo = tokens
	for key in tokens:
		var token_list = []
		for token in tokens[key]:
			for _i in range (0,tokens[key][token]["Count"],1):
				token_list.append(token)
		GameVariables.available_tokens[key] = token_list


func _load():
	var load_dict = _readJson(rootJsons + savePath +"save1.save")
	StateController._load(load_dict)

func load_file(var file):
	var load_dict = _readJson(rootJsons + savePath + file)
	StateController._load(load_dict)

func _save():
	var save_dict = StateController._save()
	var save_game = File.new()
	
	save_game.open(rootJsons + savePath + GameVariables.gameName + ".save", File.WRITE)
	save_game.store_line(to_json(save_dict))
	save_game.close()


func get_saved_files():
	var files = []
	var dir = Directory.new()
	dir.open(rootJsons + savePath)
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(file)

	dir.list_dir_end()

	return files
