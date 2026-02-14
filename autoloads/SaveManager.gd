extends Node

const PATH = ""

enum HEX_TYPE {
	BASE,
	FRUIT,
	MIGRATED,
	FLY
}

var HEX_DICT : Dictionary[HEX_TYPE, PackedScene] = {
	HEX_TYPE.BASE : HexManager.BASE_HEX,
	HEX_TYPE.FRUIT: HexManager.FRUIT_HEX,
	HEX_TYPE.MIGRATED: HexManager.MIGRATED_HEX,
	HEX_TYPE.FLY: HexManager.FLY_HEX
}


var current_save : int
var city_name : String

func save_game():
	var path = PATH + str(current_save)
	save_file(path)
	
func load_game(save_num : int):
	current_save = save_num
	var path = PATH + str(current_save)
	load_file(path)

#saving a specific file for a given path
func save_file(save_path : String):
	var data : SaveData = SaveData.new()
	
	data.num_flies = GameInfo.num_flies
	var hexes = []
	for hex in HexManager.hex_list:
		hexes.append(hex.data)
	data.hex_list = hexes
	data.city_name = city_name

#reading from selected save_path to regenerate the game
func load_file(save_path : String):
	var loaded_save = ResourceLoader.load(save_path,"",ResourceLoader.CACHE_MODE_REUSE)
	city_name = loaded_save.city_name
	GameInfo.num_flies = loaded_save.num_flies
	#hex map loading
	for i in loaded_save.hex_list:
		HexManager.create_hex(i.grid_coords,HEX_DICT[i.hex_type],BaseHex.CREATE_TYPE.INSTANT,i.extra_params)
	GameInfo.num_flies = loaded_save.num_flies
