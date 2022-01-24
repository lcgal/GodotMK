extends Node

var turnPhaseLabel
var phaseInfo

var turnPhase

var optionsPopup
var dismissPopup
var confirmationPopup

var combatLane

func _ready():
	StateController.turnManager = self

func _startGame():
	_startPhase(Constants.TurnPhase.MOVEMENT)
	Configs._loadTokensInfo()

func _save():
	var save_dict = {}
	save_dict["turnPhase"] = turnPhase
	return save_dict

func _load(var save_dict):
	var phase = save_dict["turnPhase"]
	_startPhase(phase)

func _confirm():
	endPhase()

func _resetActions():
	StateController.board._movementReset()
	StateController.player1._resetTurn()
	StateController.handGUI._resetTurn()

func _startPhase(var phase):
	turnPhase = phase
	if phase == Constants.TurnPhase.MOVEMENT:
		turnPhaseLabel.text = "Movement"
		phaseInfo.text = "Move points: " + str(0)
		StateController.player1._drawToHandLimit()
	elif phase == Constants.TurnPhase.COMBAT_BEGIN:
		turnPhase = Constants.TurnPhase.COMBAT_BEGIN
		turnPhaseLabel.text = "Combat"
		phaseInfo.text = ""
		endPhase()
	elif phase == Constants.TurnPhase.COMBAT_RANGED_PHASE:
		turnPhase = Constants.TurnPhase.COMBAT_RANGED_PHASE
		turnPhaseLabel.text = "Combat"
		phaseInfo.text = "Ranged Phase"
	elif phase == Constants.TurnPhase.COMBAT_BLOCK_PHASE:
		turnPhase = Constants.TurnPhase.COMBAT_BLOCK_PHASE
		phaseInfo.text = "Block Phase"
	elif phase == Constants.TurnPhase.COMBAT_MELEE_PHASE:
		turnPhase = Constants.TurnPhase.COMBAT_MELEE_PHASE
		phaseInfo.text = "Attack Phase"

func endPhase():
	Configs._save()
	if turnPhase == Constants.TurnPhase.MOVEMENT:
		if StateController.player1.movementPoints >= 0:
			StateController.player1.movementPoints = 0
			_startPhase(Constants.TurnPhase.COMBAT_BEGIN)
	elif turnPhase == Constants.TurnPhase.COMBAT_BEGIN:
		_startPhase(Constants.TurnPhase.COMBAT_RANGED_PHASE)
	elif turnPhase == Constants.TurnPhase.COMBAT_RANGED_PHASE:
		StateController.combatBoard._endCombatPhase(turnPhase)
		_startPhase(Constants.TurnPhase.COMBAT_BLOCK_PHASE)
	elif turnPhase == Constants.TurnPhase.COMBAT_BLOCK_PHASE:
		StateController.combatBoard._endCombatPhase(turnPhase)
		_startPhase(Constants.TurnPhase.COMBAT_MELEE_PHASE)
		

func _lockActions():
	StateController.board.startPos = StateController.player1.position
	StateController.handGUI._lockPlayedCards()

func _updateMovementPonts(var value):
	if value < 0:
		phaseInfo.bbcode_text = "Move points: [color=#FF1B00]" + str(value)
	elif value > 0:
		phaseInfo.bbcode_text = "Move points: [color=#00FF00]" + str(value)
	else:
		phaseInfo.bbcode_text = "Move points: " + str(value)

func _startCombat(var tokens):
	_startPhase(Constants.TurnPhase.COMBAT_BEGIN)
	StateController.combatBoard._startCombat(tokens)
	
func _endTurn():
	_lockActions()
	StateController.handGUI._discardCards()
