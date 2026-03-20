extends Node

### AUTOLOAD

### GameManager
## Manages the flow of the game with game_loop. Mostly calls methods in other autoloads and sends/receives signals.

## Tick timing
const tick_duration : float = 0.5 #in seconds
var time_since_last_tick : float = 0

func _ready() -> void:
	SignalBus.quit_pressed.connect(quit_game)
	SignalBus.skip_to_win_pressed.connect(end_game)
	SignalBus.start_game_pressed.connect(start_game)

func _physics_process(_delta: float) -> void:
	tick(_delta)

func tick(_delta: float) :
	time_since_last_tick += _delta
	if time_since_last_tick > tick_duration :
		time_since_last_tick -= tick_duration
		HexManager.tick()

func start_game(args: Array) :
	if !SaveManager.load_game(args[0]):
		HexManager._allow_modify_actions = true
		var size = 2
		for coord in HexManager.get_coords_in_hexagon(size) :
			HexManager.create_hex(coord, HexManager.FRUIT_HEX, BaseHex.CREATE_TYPE.FADE_IN, [randi_range(0,3)])
			
		SaveManager.city_name = "City %d" % args[0]

func end_game() :
	HexManager.remove_all_hexes()
	HexManager._allow_modify_actions = false

func quit_game() :
	get_tree().quit()
