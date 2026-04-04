extends Node

### AUTOLOAD

### GameManager
## Manages the flow of the game with game_loop. Mostly calls methods in other autoloads and sends/receives signals.

## Tick timing
const tick_duration : float = 1.0 #in seconds
var time_since_last_tick : float = 0
var tick_counter : int = 0

func _ready() -> void:
	SignalBus.quit_pressed.connect(quit_game)
	SignalBus.skip_to_win_pressed.connect(end_game)
	SignalBus.start_game_pressed.connect(start_game)

func _physics_process(_delta: float) -> void:
	tick(_delta)

func tick(_delta: float) :
	time_since_last_tick += _delta
	#print("time since last tick: %f" % time_since_last_tick)
	if time_since_last_tick > tick_duration :
		time_since_last_tick -= tick_duration
		HexManager.tick()
		
		# day tracking
		if tick_counter == GameInfo.day_length:
			GameInfo.day_num += 1
			tick_counter = 0
		tick_counter += 1
		
func start_game() :
	HexManager._allow_modify_actions = true
	for coord in HexManager.get_coords_in_hexagon(GameInfo.level_radius) :
		HexManager.create_hex(coord, HexManager.FRUIT_HEX, BaseHex.CREATE_TYPE.FADE_IN, [randi_range(0,3)])
	
	# start day tracking timer
	tick_counter = 0

func end_game() :
	HexManager.remove_all_hexes()
	HexManager._allow_modify_actions = false

func quit_game() :
	get_tree().quit()

#reading from selected save_path to regenerate the game
func load_file(save_path : String):
	#base hex scenes to prepare for create_hex reading from save
	var hex_type_to_scene : Dictionary[String,PackedScene] = {
		"base" : HexManager.BASE_HEX,
		"fruit": HexManager.FRUIT_HEX,
		"migration": HexManager.MIGRATED_HEX
	}
	var loaded_save = ResourceLoader.load(save_path,"",ResourceLoader.CACHE_MODE_REUSE)
	#hex map loading
	for i in loaded_save.hex_list:
		HexManager.create_hex(i.coords,hex_type_to_scene.get(i.type),BaseHex.CREATE_TYPE.INSTANT,i.extra_params)
