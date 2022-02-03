extends Node2D

func _ready():
	StateController.game = self
	if StateController.loadedGame == null:
		_newGame()
	else:
		_loadGame()

func _newGame():
	Configs._loadMap(Constants.Maps.WEDGE)
	StateController.board._initializeNew()

	SceneInitializer._initializePlayer(Constants.Knights.TOVAK)
	var datetime = OS.get_datetime()
	GameVariables.gameName = str(datetime["year"]) + "-" + str(datetime["month"]) + "-" + str(datetime["day"]) + "-" + str(datetime["hour"]) + str(datetime["minute"]) + str(datetime["second"])
	TurnManager._startGame()

func _loadGame():
	SceneInitializer._initializePlayer(Constants.Knights.TOVAK)
	Configs.load_file(StateController.loadedGame)
	


func _close():
	StateController._quit()
	queue_free()
