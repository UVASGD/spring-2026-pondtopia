extends Node

const FLOOD_CHANCE = 0.5
const EARTHQUAKE_CHANCE = 0.5

func smite_those_frogs(cur_disaster: String):
	var defended = []
	match cur_disaster:
		"flood":
			for hex in HexManager.hex_list:
				if hex.get_script().get_global_name() == "DamHex":
					for defended_hex in hex.send_defend_tiles():
						defended.append(defended_hex)
			
			var at_risk = []
			for hex in HexManager.hex_list:
				if hex not in defended:
					at_risk.append(hex)
			for hex in at_risk:
				var temp = randf()
				if temp < FLOOD_CHANCE:
					hex.remove_from_map()
			
		"fire":
			pass
		"earthquake":
			for hex in HexManager.hex_list:
				# TODO: change DamHex to earthquake protection thingy
				if hex.get_script().get_global_name() == "DamHex":
					for defended_hex in hex.send_defend_tiles():
						defended.append(defended_hex)
			var at_risk = []
			for hex in HexManager.hex_list:
				if hex not in defended:
					at_risk.append(hex)

			var size = at_risk.size()
			if size <= 2: return
			for hex: BaseHex in at_risk:
				var temp = randf()
				if temp < EARTHQUAKE_CHANCE:
					# swap current hex with random tile
					var temp_tile: BaseHex = at_risk.pick_random()
					var temp_tile_coords = temp_tile.data.grid_coords
					var hex_coords = hex.data.grid_coords
					temp_tile.remove_from_map()
					hex.remove_from_map()
					HexManager.create_hex(temp_tile_coords, temp_tile.data.hex_scene_type, BaseHex.CREATE_TYPE.INSTANT)
					HexManager.create_hex(hex_coords, hex.data.hex_scene_type, BaseHex.CREATE_TYPE.INSTANT)
					
					
			
		"meteor":
			for hex in HexManager.hex_list:
				if hex.get_script().get_global_name() == "DamHex":
					for defended_hex in hex.send_defend_tiles():
						defended.append(defended_hex)
			
			var at_risk = []
			for hex in HexManager.hex_list:
				if hex not in defended:
					at_risk.append(hex)
			for hex in at_risk:
				hex.remove_from_map()
			 
