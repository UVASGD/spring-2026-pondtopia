extends Node

### AUTOLOAD

### GameInfo ###
## Game state flags vars and funcs.

var game_running: bool = false
var num_flies: int = 200
var num_frogs: int = 3
var frog_capacity: int = 10
var frog_move_in_rate: int = 3 # the rate at which frogs move into the city
var day_num: int = 1
var day_length: int = 200 # in seconds
var level_radius : int = 2 #radius of level hexagon in hexes
var cur_selected_tile: HexManager.HexType = HexManager.HexType.BASEHEX
var disaster_arr = ["earthquake", "fire", "fire"]
var disaster_num: int = 0
var happiness : int = 100
var energy : int = 100
var num_houses: int = 0
