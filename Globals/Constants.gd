extends Node

enum Knights {
	TOVAK,
}

enum Maps {
	WEDGE,
}

enum turn_phase {
	MOVEMENT,
	COMBAT_RANGED_PHASE,
	COMBAT_BLOCK_PHASE,
	COMBAT_MELEE_PHASE,
	INTERACTION,
}

var hexes = {
	"E" : {"x" : 1,"y" :-1},
	"W" : {"x" : -1,"y" :1},
	"SW" : {"x" : 0,"y" :1},
	"NE" : {"x" : 0,"y" :-1},
	"NW" : {"x" : -1,"y" :0},
	"SE" : {"x" : 1,"y" :0},
	"C" : {"x" : 0,"y" :0},
}

var relevant_effects = {
	turn_phase.MOVEMENT : ["Move","Support"],
	turn_phase.COMBAT_RANGED_PHASE : ["Ranged","Siege","Attack"],
	turn_phase.COMBAT_BLOCK_PHASE : ["Block"],
	turn_phase.COMBAT_MELEE_PHASE : ["Attack"],
	turn_phase.INTERACTION : ["Support","Influence"],
}

var sideway_effects = {
	"Move" : {"Effect" : [{"Action" : "AddMove", "Value" : 2}], "Text" : "Play sideways to add 1 movement"},
	"Attack" : {"Effect" : [{"Action" : "AddAttack", "Value" : 2, "Type" : "Physical"}], "Text" : "Play sideways to add 1 attack"},
	"Block" : {"Effect" : [{"Action" : "AddBlock", "Value" : 2, "Type" : "Physical"}], "Text" : "Play sideways to add 1 block"},
}

var features = {
	"Hold" : {"Type" : "Hold", "Owner" : null, "Token" : "Grey", "Revealed" : false, "AutoCombat" : true},
	"MageTower" : {"Type" : "MageTower", "Owner" : null, "Token" : "Violet", "Revealed" : false, "AutoCombat" : true},
	"Rampaging" : {"Type" : "Rampaging", "Owner" : null, "Token" : "Green", "Revealed" : false, "AutoCombat" : true},
}
