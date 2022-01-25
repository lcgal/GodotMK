extends Node2D
var root = "/root/Game/"

func _ready():
	var load_dict
	if 1 == 1:
		Configs._load()
	else:
		Configs._loadMap(Constants.Maps.WEDGE)
		StateController.board._initializeNew()

	SceneInitializer._initializePlayer(Constants.Knights.TOVAK)
	TurnManager._startGame()
		
	

