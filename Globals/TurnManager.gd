extends Node

var turnPhaseLabel
var phaseInfo

var turnPhase

var playCardPopup
var dismissPopup
var confirmationPopup

var combatLane

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
	elif phase == Constants.TurnPhase.COMBAT_BEGIN:
		turnPhase = Constants.TurnPhase.COMBAT_BEGIN
		turnPhaseLabel.text = "Combat"
		phaseInfo.text = ""
	elif phase == Constants.TurnPhase.COMBAT_RANGED_PHASE:
		turnPhase = Constants.TurnPhase.COMBAT_RANGED_PHASE
		turnPhaseLabel.text = "Combat"
		phaseInfo.text = "Ranged Phase"
	elif phase == Constants.TurnPhase.COMBAT_BLOCK_PHASE:
		turnPhase = Constants.TurnPhase.COMBAT_BLOCK_PHASE
		phaseInfo.text = "Block Phase"
	elif phase == Constants.TurnPhase.COMBAT_DAMAGE_PHASE:
		turnPhase = Constants.TurnPhase.COMBAT_DAMAGE_PHASE
		phaseInfo.text = "Attack Phase"

func endPhase():
	if turnPhase == Constants.TurnPhase.MOVEMENT:
		if GameVariables.player1.movementPoints >= 0:
			GameVariables.player1.movementPoints = 0
			_startPhase(Constants.TurnPhase.COMBAT_BEGIN)
	elif turnPhase == Constants.TurnPhase.COMBAT_BEGIN:
#		_lockActions()
#		GameVariables.handGUI._discardCards()
		_startPhase(Constants.TurnPhase.COMBAT_RANGED_PHASE)
	elif turnPhase == Constants.TurnPhase.COMBAT_RANGED_PHASE:
#		_lockActions()
#		GameVariables.handGUI._discardCards()
		_startPhase(Constants.TurnPhase.COMBAT_BLOCK_PHASE)
	elif turnPhase == Constants.TurnPhase.COMBAT_BLOCK_PHASE:
#		_lockActions()
#		GameVariables.handGUI._discardCards()
		_startPhase(Constants.TurnPhase.COMBAT_DAMAGE_PHASE)
		

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
	_startPhase(Constants.TurnPhase.COMBAT_BEGIN)
	GameVariables.combatBoard._startCombat(tokens)

func _passCombatPhase():
	GameVariables.combatBoard._passCombatPhase()
