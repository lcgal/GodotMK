extends Node

var turnPhaseLabel
var phaseInfo

var turnPhase

var playCardPopup
var dismissPopup
var confirmationPopup


func _startGame():
	_startPhase(Constants.TurnPhase.MOVEMENT)
	Configs._loadTokensInfo()

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
		_lockActions()
		GameVariables.handGUI._discardCards()
		_startPhase(Constants.TurnPhase.MOVEMENT)

func _lockActions():
	GameVariables.board.startPos = GameVariables.player1.position
	GameVariables.handGUI._lockPlayedCards()

func _updateMovementPonts(var value):
	if value < 0:
		phaseInfo.bbcode_text = "Move points: [color=#FF1B00]" + str(value)
	elif value > 0:
		phaseInfo.bbcode_text = "Move points: [color=#00FF00]" + str(value)
	else:
		phaseInfo.bbcode_text = "Move points: " + str(value)

func _startCombat(var tokens):
	GameVariables.combatBoard._startCombat(tokens)
	
