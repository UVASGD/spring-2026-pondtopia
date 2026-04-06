extends Node

const PATH = ["user://SaveData", ".tres"]
const SaveData = preload("res://autoloads/SaveData.gd")

enum HEX_TYPE {
	BASE,
	FRUIT,
	MIGRATED,
	FLY,
	DAM
}

var HEX_DICT : Dictionary[HEX_TYPE, PackedScene] = {
	HEX_TYPE.BASE : HexManager.BASE_HEX,
	HEX_TYPE.FRUIT: HexManager.FRUIT_HEX,
	HEX_TYPE.MIGRATED: HexManager.MIGRATED_HEX,
	HEX_TYPE.FLY: HexManager.FLY_HEX,
	HEX_TYPE.DAM: HexManager.DAM_HEX
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
	var names : Array[String] = []
	for i in range(3):
		var path = PATH[0] + str(i+1) + PATH[1]
		var loaded_save = ResourceLoader.load(path,"",ResourceLoader.CACHE_MODE_REUSE)
		if loaded_save == null:
			names.append("Save %d" % (i+1))
		else:
			names.append(loaded_save.city_name)
	return names

#saving a specific file for a given path
func save_file(save_path : String):
	print("Saving to path: " + save_path)
	
	var data = SaveData.new()
	
	data.num_flies = GameInfo.num_flies
	var hexes : Array = []
	for hex in HexManager.hex_list:
		hexes.append(hex.data)
		print(hex.data, hex.data.grid_coords, HEX_TYPE.find_key(hex.data.hex_type))
	data.hex_list = hexes
	data.city_name = city_name
	
	ResourceSaver.save(data, save_path)

#reading from selected save_path to regenerate the game
func load_file(save_path : String):
	var loaded_save = ResourceLoader.load(save_path,"",ResourceLoader.CACHE_MODE_REUSE)
	if loaded_save == null : return false
	city_name = loaded_save.city_name
	GameInfo.num_flies = loaded_save.num_flies
	#hex map loading
	HexManager._allow_modify_actions = true
	for i in loaded_save.hex_list:
		print(i.grid_coords, HEX_TYPE.find_key(i.hex_type))
		HexManager.create_hex(i.grid_coords,HEX_DICT[i.hex_type],BaseHex.CREATE_TYPE.INSTANT)#,i.extra_params)
	GameInfo.num_flies = loaded_save.num_flies
	return true

# Debug func REMOVE
func _unhandled_key_input(event: InputEvent) -> void:
	if event.pressed and event.keycode == KEY_SPACE:
		save_game()
		print("Game Saved! (I think...)")
	if event.pressed and event.keycode == KEY_SHIFT:
		for i in range(3):
			var path = PATH[0] + str(i+1) + PATH[1]
			DirAccess.remove_absolute(path)
