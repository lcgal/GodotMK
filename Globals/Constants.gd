extends Node

enum Knights {
	TOVAK,
}

enum Maps {
	WEDGE,
}

enum TurnPhase {
	MOVEMENT,
	COMBAT,
}

var sidewayMove = {"Effect" : "AddMove", "Value" : 1}
var sidewayAttack = {"Effect" : "AddAttack", "Value" : 1, "Type" : "Physical"}
