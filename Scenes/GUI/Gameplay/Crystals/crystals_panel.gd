extends Control

var green
var red
var blue
var white
var black
var gold

func _ready():
	green = get_node("GreenCrystal")
	green.set_texture(Assets.crystal("greenCrystal.png"))
	red = get_node("RedCrystal")
	red.set_texture(Assets.crystal("redCrystal.png"))
	blue = get_node("BlueCrystal")
	blue.set_texture(Assets.crystal("blueCrystal.png"))
	white = get_node("WhiteCrystal")
	white.set_texture(Assets.crystal("whiteCrystal.png"))
	black = get_node("BlackCrystal")
	black.set_texture(Assets.crystal("blackCrystal.png"))
	gold = get_node("GoldCrystal")
	gold.set_texture(Assets.crystal("goldCrystal.png"))

