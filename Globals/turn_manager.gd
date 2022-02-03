extends Node

var currentTurn = 0
var turnLabel
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
	Configs._loadTokensInfo()
	_startTurn()

func _save():
	var save_dict = {}
	save_dict["turnPhase"] = turnPhase
	save_dict["turnPhaseLabel"] = turnPhaseLabel.text
	save_dict["phaseInfo"] = phaseInfo.text
	
	return save_dict

func _load(var save_dict):
	var phase = save_dict["turnPhase"]
	turnPhaseLabel.text = save_dict["turnPhaseLabel"]
	phaseInfo.text = save_dict["phaseInfo"]

func _confirm():
	if _lockActions():
		endPhase()

func _resetActions():
	StateController._reset()
	StateController.board._movementReset()
	StateController.player1._resetTurn()

func _startPhase(var phase):
	turnPhase = phase
	if phase == Constants.TurnPhase.MOVEMENT:
		turnPhaseLabel.text = "Movement"
		phaseInfo.text = "Move points: " + str(0)
		StateController.player1._drawToHandLimit()
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
	elif phase == Constants.TurnPhase.INTERACTION:
		turnPhase = Constants.TurnPhase.INTERACTION
		turnPhaseLabel.text = "Interaction"
		phaseInfo.text = "Interaction Phase"

func endPhase():
	if turnPhase == Constants.TurnPhase.MOVEMENT:
		StateController.player1.movementPoints = 0
		_startPhase(Constants.TurnPhase.INTERACTION)
	elif turnPhase == Constants.TurnPhase.COMBAT_RANGED_PHASE:
		StateController.combatBoard._endCombatPhase(turnPhase)
		_startPhase(Constants.TurnPhase.COMBAT_BLOCK_PHASE)
	elif turnPhase == Constants.TurnPhase.COMBAT_BLOCK_PHASE:
		StateController.combatBoard._endCombatPhase(turnPhase)
		_startPhase(Constants.TurnPhase.COMBAT_MELEE_PHASE)
	elif turnPhase == Constants.TurnPhase.INTERACTION:
		_endTurn()


func _lockActions():
	if turnPhase == Constants.TurnPhase.MOVEMENT:
		if (StateController.player1.movementPoints < 0):
			TurnManager.dismissPopup.dialog_text = "Not enough movement points"
			TurnManager.dismissPopup.popup_centered_minsize(Vector2(300,200))
			return false
		StateController.board.startPos = StateController.player1.position
		StateController.player1.lock_cards()
	return true

func _updateMovementPoints(var value):
	if value < 0:
		phaseInfo.bbcode_text = "Move points: [color=#FF1B00]" + str(value)
	elif value > 0:
		phaseInfo.bbcode_text = "Move points: [color=#00FF00]" + str(value)
	else:
		phaseInfo.bbcode_text = "Move points: " + str(value)

func _startCombat(var tokens):
	_startPhase(Constants.TurnPhase.COMBAT_RANGED_PHASE)
	StateController.combatBoard._startCombat(tokens)
	
func _endTurn():
	_lockActions()
	StateController.player1.discard_cards()
	_startTurn()

func _startTurn():
	currentTurn += 1
	_startPhase(Constants.TurnPhase.MOVEMENT)
	turnLabel.text = TextBuilder._turnText(currentTurn)
	
