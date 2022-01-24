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
	COMBAT_MELEE_PHASE,
}

var RelevantEffects = {
	TurnPhase.MOVEMENT : ["Move"],
	TurnPhase.COMBAT_RANGED_PHASE : ["Ranged","Siege","Attack"],
	TurnPhase.COMBAT_BLOCK_PHASE : ["Block"],
	TurnPhase.COMBAT_MELEE_PHASE : ["Attack"]
}

var sidewayEffects = {
	"Move" : {"Effect" : "AddMove", "Value" : 2, "Text" : "Play sideways to add 1 movement"},
	"Attack" : {"Effect" : "AddAttack", "Value" : 2, "Type" : "Physical", "Text" : "Play sideways to add 1 attack"},
	"Block" : {"Effect" : "AddBlock", "Value" : 2, "Type" : "Physical", "Text" : "Play sideways to add 1 block"}
}

var features = {
	"Hold" : {"Type" : "Hold", "Owner" : null, "Token" : "Grey", "Revealed" : false, "AutoCombat" : true}
}
