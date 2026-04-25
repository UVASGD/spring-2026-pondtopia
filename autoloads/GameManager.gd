extends Node

### AUTOLOAD

### GameManager
## Manages the flow of the game with game_loop. Mostly calls methods in other autoloads and sends/receives signals.

## Tick timing
const tick_duration : float = 1.0 #in seconds
var time_since_last_tick : float = 0
var tick_counter : int = 0
var last_disaster_day: int

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
		
		# day tracking
		if GameInfo.game_running:
			if tick_counter == GameInfo.day_length:
				GameInfo.day_num += 1
				tick_counter = 0
				SaveManager.save_game()
			tick_counter += 1
			# start a disaster
			if GameInfo.day_num % 7 == 0 and tick_counter == 1: # only runs once per day
				var cur_disaster = GameInfo.disaster_arr[GameInfo.disaster_num]
				DisasterManager.smite_those_frogs(cur_disaster)
				GameInfo.disaster_num += 1
				last_disaster_day = GameInfo.day_num
			if GameInfo.day_num == last_disaster_day + 1 and tick_counter == 1: # new frogs move in at the start of each week
					# if more frogs want to move in than the fro capacity allows num_frogs = frog_capacity
					if GameInfo.num_frogs + GameInfo.frog_move_in_rate > GameInfo.frog_capacity:
						GameInfo.num_frogs = GameInfo.frog_capacity
					GameInfo.num_frogs += GameInfo.frog_move_in_rate
			if GameInfo.num_houses % 3 == 0: # 3 more frogs can move in per week per 3 housing tiles
				GameInfo.frog_move_in_rate += 3
			if GameInfo.happiness < 50:
				GameInfo.frog_move_in_rate = 1
			if GameInfo.disaster_num > 3: GameInfo.disaster_num = 3
	#BarsManager.updateHappy()


func start_game(state : int) :
	if !SaveManager.load_game(state):
		HexManager._allow_modify_actions = true
		for coord in HexManager.get_coords_in_hexagon(GameInfo.level_radius):
			HexManager.create_hex(coord, HexManager.FRUIT_HEX, BaseHex.CREATE_TYPE.FADE_IN, [randi_range(0,3)])
		
		GameInfo.disaster_arr.shuffle()
		GameInfo.disaster_arr.append("meteor")
		GameInfo.num_flies = 200
		GameInfo.num_frogs = 1
		GameInfo.frog_capacity = 10
		GameInfo.day_num = 1
		GameInfo.happiness = 100
		GameInfo.energy = 100
		SaveManager.city_name = "City %d" % state
	
	tick_counter = 0
	GameInfo.game_running = true

func end_game() :
	HexManager.remove_all_hexes()
	HexManager._allow_modify_actions = false
	
	GameInfo.game_running = false


func quit_game() :
	get_tree().quit()

"""
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
"""
