extends Node

var game_name

#Map
var DefaultResolution = Vector2(1920,1062)
var x_vector = Vector2(381,-323)
var y_vector = Vector2(-95,-484)
var explorable_tiles_info
var map_tile_info
var countryside_tile_list
var core_tile_list
var countryside_tiles_left
var core_tiles_left
var city_count
var city_tiles
var core_tiles
var movement_costs
var current_movement_cost = 0
var tile_distance = 200
var hex_distance = 200
var tokens_info
var available_tokens



#Cards
var action_cards 

func _ready():
	action_cards = Configs.get_actions_cards_info()
	StateController.game_variables = self

var savable_properties = [
	"game_name",
	"explorable_tiles_info",
	"map_tile_info",
	"countryside_tile_list",
	"core_tile_list",
	"countryside_tiles_left",
	"core_tiles_left",
	"city_count",
	"city_tiles",
	"core_tiles",
	"movement_costs",
	"tokens_info",
	"available_tokens"
]

func save_game():
	var save_dict = {}
	for key in savable_properties:
		save_dict[key] = get(key)
	
	return save_dict

func load_game(var save_dict):
	for key in save_dict:
		set(key, save_dict[key])


func new_game():
	available_tokens = {}
	countryside_tile_list = []
	core_tile_list = []
	core_tiles = []
	city_tiles = []


func set_map_data(var map_data, var tiles_data, var movement_data, var token_data):
	explorable_tiles_info = map_data["ExplorableTiles"]
	countryside_tiles_left = map_data["CountrysideTiles"]
	core_tiles_left = map_data["CoreTiles"]
	city_count = map_data["Cities"]
	map_tile_info = tiles_data
	movement_costs = movement_data
	
	tokens_info = token_data
	
	for key in tokens_info:
		
		var token_list = []
		for token in tokens_info[key]:
			for _i in range (0,tokens_info[key][token]["Count"],1):
				token_list.append(token)
		available_tokens[key] = token_list
	
	
	_set_map_tile_options()
		
func _set_map_tile_options():
	randomize()
	for tile in map_tile_info["CountrySideTiles"]:
		countryside_tile_list.append(tile)
	
	for tile in map_tile_info["CoreTiles"]:
		if (map_tile_info["CoreTiles"][tile]["isCity"]):
			city_tiles.append(tile)
		else:
			core_tiles.append(tile)

	for _i in range(0,city_count,1):
		var index = randi() % city_tiles.size()
		var tile = city_tiles[index]
		city_tiles.remove(index)
		core_tile_list.append(tile)
	for _i in range(0,core_tiles_left - city_count,1):
		var index = randi() % core_tiles.size()
		var tile = core_tiles[index]
		core_tiles.remove(index)
		core_tile_list.append(tile)
