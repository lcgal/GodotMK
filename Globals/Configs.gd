extends Node

const JSONS_ROOT = "res://ConfigJsons/"
const KNIGHTS_PATH = JSONS_ROOT + "Knights/"
const CARDS_PATH = JSONS_ROOT +  "Cards/"
const SAVE_PATH = JSONS_ROOT +  "Saves/"

func read_json(var json):
	var file = File.new()
	file.open(json,file.READ)
	var jsonInfo = file.get_as_text()
	file.close()
	return JSON.parse(jsonInfo).result

func get_knight_info(var knight):
	if knight == Constants.Knights.TOVAK:
		return read_json(KNIGHTS_PATH + "Tovak.json")

func get_map_info(var map):
	if map == Constants.Maps.WEDGE:
		var map_data = read_json(JSONS_ROOT + "WedgeMapTiles.json")
		var tiles_data = _get_tiles_info()
		var movement_data = _get_movement_info()
		GameVariables.set_map_data(map_data, tiles_data, movement_data)
		
func get_actions_cards_info():
	return read_json(CARDS_PATH + "Actions.json")

func _get_tiles_info():
	return read_json(JSONS_ROOT +"MapTiles.json")

func _get_movement_info():
	return read_json(JSONS_ROOT + "MovementCosts.json")

func load_tokens_info():
	var tokens = read_json(JSONS_ROOT + "Tokens.json")
	GameVariables.tokens_info = tokens
	for key in tokens:
		var token_list = []
		for token in tokens[key]:
			for _i in range (0,tokens[key][token]["Count"],1):
				token_list.append(token)
		GameVariables.available_tokens[key] = token_list


func load_file(var file):
	var load_dict = read_json(SAVE_PATH + file)
	StateController.load_game(load_dict)

func save_game():
	var save_dict = StateController.save_game()
	var save_game = File.new()
	
	save_game.open(SAVE_PATH + GameVariables.game_name + ".save", File.WRITE)
	save_game.store_line(to_json(save_dict))
	save_game.close()


func get_saved_files():
	var files = []
	var dir = Directory.new()
	dir.open(SAVE_PATH)
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(file)

	dir.list_dir_end()

	return files
