extends Node

### AUTOLOAD

### GameInfo ###
## Game state flags vars and funcs.

var game_running: bool = false
var num_flies: int = 200
var num_frogs: int = 1
var frog_capacity: int = 10
var day_num: int = 1
var day_length: int = 1 # in seconds
var cur_selected_tile: String = ""
var disaster_arr = ["fire", "flood", "earthquake"]
var disaster_num: int = 0
