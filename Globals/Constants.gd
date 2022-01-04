extends Node

enum Knights {
	TOVAK,
}

enum Maps {
	WEDGE,
}

enum TurnPhase {
	MOVEMENT,
	COMBAT_BEGIN,
	COMBAT_RANGED_PHASE,
	COMBAT_BLOCK_PHASE,
	COMBAT_DAMAGE_PHASE,
}

var sidewayMove = {"Effect" : "AddMove", "Value" : 1}
var sidewayAttack = {"Effect" : "AddAttack", "Value" : 1, "Type" : "Physical"}
