extends Node

### AUTOLOAD

### GameManager
## Manages the flow of the game with game_loop. Mostly calls methods in other autoloads and sends/receives signals.

## Tick timing
const tick_duration : float = 0.1 #in seconds
var time_since_last_tick : float = 0


func _physics_process(_delta: float) -> void:
	tick(_delta)

func tick(_delta: float) :
	time_since_last_tick += _delta
	if time_since_last_tick > tick_duration :
		time_since_last_tick -= tick_duration
		HexManager.tick()

func start_game() :
	var size = 2
	for coord in HexManager.get_coords_in_hexagon(size) :
		HexManager.create_hex(coord, BaseHex.HEX_SCENES.MIGRATED, BaseHex.CREATE_TYPE.FADE_IN)
		await get_tree().create_timer(0.05).timeout

func end_game() :
	HexManager.remove_all_hexes()
