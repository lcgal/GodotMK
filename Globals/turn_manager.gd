extends Node

var current_turn = 0
var turn_label
var turn_phase_label
var phase_info

var turn_phase

var options_popup
var dismiss_popup
var confirmation_popup

var combat_lane

func _ready():
	StateController.turn_manager = self


func _startGame():
	_start_turn()


func save_game():
	var save_dict = {}
	save_dict["turn_phase"] = turn_phase
	save_dict["turn_phase_label"] = turn_phase_label.text
	save_dict["phase_info"] = phase_info.text
	save_dict["current_turn"] = current_turn
	
	return save_dict


func load_game(var save_dict):
	turn_phase = int(save_dict["turn_phase"])
	turn_phase_label.text = save_dict["turn_phase_label"]
	phase_info.text = save_dict["phase_info"]
	current_turn = save_dict["current_turn"]
	turn_label.text = TextBuilder.turn_text(current_turn)


func confirm():
	if lock_actions():
		end_phase()


func start_phase(var phase):
	turn_phase = phase
	if phase == Constants.turn_phase.MOVEMENT:
		turn_phase_label.text = "Movement"
		phase_info.text = "Move points: " + str(0)
		StateController.player1.draw_to_hand_limit()
	elif phase == Constants.turn_phase.COMBAT_RANGED_PHASE:
		turn_phase = Constants.turn_phase.COMBAT_RANGED_PHASE
		turn_phase_label.text = "Combat"
		phase_info.text = "Ranged Phase"
	elif phase == Constants.turn_phase.COMBAT_BLOCK_PHASE:
		turn_phase = Constants.turn_phase.COMBAT_BLOCK_PHASE
		phase_info.text = "Block Phase"
	elif phase == Constants.turn_phase.COMBAT_MELEE_PHASE:
		turn_phase = Constants.turn_phase.COMBAT_MELEE_PHASE
		phase_info.text = "Attack Phase"
	elif phase == Constants.turn_phase.INTERACTION:
		turn_phase = Constants.turn_phase.INTERACTION
		turn_phase_label.text = "Interaction"
		phase_info.text = "Interaction Phase"


func end_phase():
	if turn_phase == Constants.turn_phase.MOVEMENT:
		StateController.player1.movement_points = 0
		start_phase(Constants.turn_phase.INTERACTION)
	elif turn_phase == Constants.turn_phase.COMBAT_RANGED_PHASE:
		StateController.combat_board.end_combat_phase(turn_phase)
		start_phase(Constants.turn_phase.COMBAT_BLOCK_PHASE)
	elif turn_phase == Constants.turn_phase.COMBAT_BLOCK_PHASE:
		StateController.combat_board.end_combat_phase(turn_phase)
		start_phase(Constants.turn_phase.COMBAT_MELEE_PHASE)
	elif turn_phase == Constants.turn_phase.COMBAT_MELEE_PHASE:
		StateController.combat_board.end_combat(false)
		_end_turn()
	elif turn_phase == Constants.turn_phase.INTERACTION:
		_end_turn()
		


func lock_actions():
	if lockable():
		Configs.save_game()
		return true


func lockable():
	if turn_phase == Constants.turn_phase.MOVEMENT:
		if (StateController.player1.movement_points < 0):
			TurnManager.dismiss_popup.dialog_text = "Not enough movement points"
			TurnManager.dismiss_popup.popup_centered_minsize(Vector2(300,200))
			return false
		StateController.board.start_pos = StateController.player1.position
		StateController.player1.lock_cards()
	return true


func update_movement_points(var value):
	if value < 0:
		phase_info.bbcode_text = "Move points: [color=#FF1B00]" + str(value)
	elif value > 0:
		phase_info.bbcode_text = "Move points: [color=#00FF00]" + str(value)
	else:
		phase_info.bbcode_text = "Move points: " + str(value)


func start_combat(var tokens, var move_back, var feature):
	start_phase(Constants.turn_phase.COMBAT_RANGED_PHASE)
	StateController.combat_board.start_combat(tokens, move_back, feature)
	lock_actions()


func _end_turn():
	lock_actions()
	StateController.player1.discard_cards()
	_start_turn()


func _start_turn():
	current_turn += 1
	start_phase(Constants.turn_phase.MOVEMENT)
	turn_label.text = TextBuilder.turn_text(current_turn)
	
