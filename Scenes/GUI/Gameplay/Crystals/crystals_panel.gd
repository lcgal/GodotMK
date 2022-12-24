extends Control

var green
var red
var blue
var white
var dark
var gold

func _connect(var player):
	player.connect("update_crystal_count", self,  "set_counter")

func set_counter(var color, var value):
	if color == "green":
		green._add_value(value)
	elif color == "red":
		red._add_value(value)
	elif color == "blue":
		blue._add_value(value)
	elif color == "white":
		white._add_value(value)
	elif color == "gold":
		gold._add_value(value)
	elif color == "dark":
		dark._add_value(value)

func _ready():
	green = get_node("GreenCrystal")
	green.set_texture(Assets.crystal("greenCrystal.png"))
	red = get_node("RedCrystal")
	red.set_texture(Assets.crystal("redCrystal.png"))
	blue = get_node("BlueCrystal")
	blue.set_texture(Assets.crystal("blueCrystal.png"))
	white = get_node("WhiteCrystal")
	white.set_texture(Assets.crystal("whiteCrystal.png"))
	dark = get_node("BlackCrystal")
	dark.set_texture(Assets.crystal("blackCrystal.png"))
	gold = get_node("GoldCrystal")
	gold.set_texture(Assets.crystal("goldCrystal.png"))

