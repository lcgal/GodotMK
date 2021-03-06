extends Node2D

func _ready():
	StateController.game = self
	StateController.new_game()
	if StateController.loaded_game == null:
		_newGame()
	else:
		_loadGame()


func _newGame():
	Configs.get_map_info(Constants.Maps.WEDGE)
	StateController.board._initializeNew()

	SceneInitializer.player(Constants.Knights.TOVAK)
	var datetime = OS.get_datetime()
	GameVariables.game_name = str(datetime["year"]) + "-" + str(datetime["month"]) + "-" + str(datetime["day"]) + "-" + str(datetime["hour"]) + str(datetime["minute"]) + str(datetime["second"])
	StateController.loaded_game = GameVariables.game_name + ".save"
	TurnManager._startGame()
	Configs.save_game()


func _loadGame():
	SceneInitializer.player(Constants.Knights.TOVAK)
	Configs.load_file(StateController.loaded_game)


func _close():
	StateController.quit_game()
	queue_free()
