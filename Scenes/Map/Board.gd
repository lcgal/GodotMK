extends Node2D

var origin = Vector2(-560,1317)
var yVector = Vector2(-96,-484)
var xVector = Vector2(380,-321)

func _ready():
	instExplorableTile(Vector2(1,0))
	instExplorableTile(Vector2(0,1))


func handleExploreTile(var explore):
	var mapTileScene = load("res://Scenes/Map/Tiles/MapTile.tscn")
	var mapTileSceneInstance = mapTileScene.instance()
	mapTileSceneInstance.global_position = explore
	add_child(mapTileSceneInstance)
	
func handlePortalTile(var location):
	print(location)

func instExplorableTile(var vector):
	var exploreTileScene = load("res://Scenes/Map/ExplorableTile.tscn")
	var exploreTileSceneInstance = exploreTileScene.instance()
	exploreTileSceneInstance.global_position = origin + vector.y*yVector + vector.x*xVector
	add_child(exploreTileSceneInstance)
	exploreTileSceneInstance.connect("exploreTile",self,"handleExploreTile")
