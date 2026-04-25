extends Node

const FLOOD_CHANCE = 0.5

func smite_those_frogs(cur_disaster: String):
	match cur_disaster:
		"flood":
			var defended = []
			for hex in HexManager.hex_list:
				if hex.data.hextype == HexManager.HexType.DAMHEX:
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
			for hex in HexManager.hex_list:
				if hex.data.hextype == HexManager.HexType.SPRINKLERHEX:
					for defended_hex in hex.send_defend_tiles():
						defended.append(defended_hex)
			var at_risk = []
			for hex in HexManager.hex_list:
				if hex not in defended:
					at_risk.append(hex)
			for hex:BaseHex in at_risk:
				var temp = randf()
				if temp < FIRE_CHANCE:
					if hex.hex_element == HexManager.HexElement.WOOD:
						hex.remove_from_map()
					
		"earthquake":
			for hex in HexManager.hex_list:
				if hex.data.hextype == HexManager.HexType.LEAFHEX:
					for defended_hex in hex.send_defend_tiles():
						defended.append(defended_hex)
			var at_risk = []
			for hex in HexManager.hex_list:
				if hex not in defended:
					at_risk.append(hex)

			var size = at_risk.size()
			if size < 2: return
			var count = 0
			for hex: BaseHex in at_risk:
				if count < at_risk.size()/2:
					# swap current hex with random tile
					var temp_hex: BaseHex = at_risk.pick_random()
					while temp_hex == hex:
						temp_hex = at_risk.pick_random()
						
					# TODO: bug fix spontaneous hex duplication
					var temp_hex_coords = temp_hex.data.grid_coords
					var hex_coords = hex.data.grid_coords
					temp_hex.remove_from_map()
					hex.remove_from_map()
					HexManager.create_hex(temp_hex_coords, HexManager.HEXGRAB[hex.data.hextype], BaseHex.CREATE_TYPE.FADE_IN)
					HexManager.create_hex(hex_coords, HexManager.HEXGRAB[temp_hex.data.hextype], BaseHex.CREATE_TYPE.FADE_IN)
					count += 1
				else: break
					
			
		"meteor":
			for hex in HexManager.hex_list:
				if hex.data.hextype == HexManager.HexType.DAMHEX:
					for defended_hex in hex.send_defend_tiles():
						defended.append(defended_hex)
			
			var at_risk = []
			for hex in HexManager.hex_list:
				if hex not in defended:
					at_risk.append(hex)
			for hex in at_risk:
				hex.remove_from_map()
			 
