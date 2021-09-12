extends Node

var turnPhaseLabel
var phaseInfo

var turnPhase

func _startGame():
	GameVariables.playCardPopup.connect("id_pressed",self,"_handleAction")
	_startPhase(Constants.TurnPhase.MOVEMENT)

func _confirm():
	endPhase()

func _resetActions():
	GameVariables.board._movementReset()
	GameVariables.player1._resetTurn()
	GameVariables.handGUI._resetTurn()

func _startPhase(var phase):
	turnPhase = phase
	if phase == Constants.TurnPhase.MOVEMENT:
		turnPhaseLabel.text = "Movement"
		phaseInfo.text = "Move points: " + str(0)
		GameVariables.player1._drawToHandLimit()
	elif phase == Constants.TurnPhase.COMBAT:
		turnPhase = Constants.TurnPhase.COMBAT
		turnPhaseLabel.text = "Combat"
		phaseInfo.text = ""

func endPhase():
	if turnPhase == Constants.TurnPhase.MOVEMENT:
		if GameVariables.player1.movementPoints >= 0:
			GameVariables.player1.movementPoints = 0
			_startPhase(Constants.TurnPhase.COMBAT)
	elif turnPhase == Constants.TurnPhase.COMBAT:
		GameVariables.handGUI._discardCards()
		_startPhase(Constants.TurnPhase.MOVEMENT)
		

func _updateMovementPonts(var value):
	if value < 0:
		phaseInfo.bbcode_text = "Move points: [color=#FF1B00]" + str(value)
	else:
		phaseInfo.bbcode_text = "Move points: " + str(value)

