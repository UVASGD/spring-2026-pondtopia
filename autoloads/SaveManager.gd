extends Node

const PATH = ["user://SaveData", ".tres"]
const SaveData = preload("res://autoloads/SaveData.gd")

var HEX_DICT : Dictionary[String, PackedScene] = {
	"BaseHex" : HexManager.BASE_HEX,
	"FruitHex" : HexManager.FRUIT_HEX,
	"MigratedHex" : HexManager.MIGRATED_HEX,
	"FlyHex" : HexManager.FLY_HEX,
	"DamHex" : HexManager.DAM_HEX,
	"HousingTile" : HexManager.HOUSE_HEX
}

var current_save : int
var city_name : String

func save_game():
	var path = PATH[0] + str(current_save) + PATH[1]
	save_file(path)
	
func load_game(save_num : int):
	current_save = save_num
	var path = PATH[0] + str(current_save) + PATH[1]
	return load_file(path)

func load_city_names():
	var names : Array = []
	for i in range(3):
		var path = PATH[0] + str(i) + PATH[1]
		var loaded_save = ResourceLoader.load(path,"",ResourceLoader.CACHE_MODE_REUSE)
		if loaded_save == null:
			names.append("Save %d" % (i+1))
		else:
			var arr : Array = [loaded_save.city_name, loaded_save.day, loaded_save.num_flies]
			names.append(arr)
	return names

#saving a specific file for a given path
func save_file(save_path : String):
	var data = SaveData.new()
	
	data.num_flies = GameInfo.num_flies
	data.day = GameInfo.day_num
	var hexes : Array = []
	for hex in HexManager.hex_list:
		hexes.append(hex.data)
	data.hex_list = hexes
	data.city_name = city_name
	
	ResourceSaver.save(data, save_path)

#reading from selected save_path to regenerate the game
func load_file(save_path : String):
	var loaded_save = ResourceLoader.load(save_path,"",ResourceLoader.CACHE_MODE_REUSE)
	if loaded_save == null : return false
	city_name = loaded_save.city_name
	GameInfo.day_num = loaded_save.day
	GameInfo.num_flies = loaded_save.num_flies
	#hex map loading
	HexManager._allow_modify_actions = true
	for i in loaded_save.hex_list:
		HexManager.create_hex(i.grid_coords,HEX_DICT[i.hex_type],BaseHex.CREATE_TYPE.INSTANT,i._extra_params)
	GameInfo.num_flies = loaded_save.num_flies
	return true

func delete_save(num : int):
	var path = PATH[0] + str(num) + PATH[1]
	DirAccess.remove_absolute(path)
