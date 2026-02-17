extends Node

### AUTOLOAD

### GameInfo ###
## Game state flags vars and funcs.

var num_flies: int = 200
var num_frogs: int = 10
var num_frogs_used: int = 0

static func get_available_frogs() -> int:
	return GameInfo.num_frogs - GameInfo.num_frogs_used
