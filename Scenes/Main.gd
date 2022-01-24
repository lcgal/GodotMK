extends Node2D
var root = "/root/Game/"

func _ready():
	
	if 1 == 1:
		var save_dict = Configs._load()
		SceneInitializer._initializePlayer(Constants.Knights.TOVAK)
		StateController._load(save_dict)

	else:
		StateController.board._initialize()
		SceneInitializer._initializePlayer(Constants.Knights.TOVAK)
		TurnManager._startGame()
		
	

