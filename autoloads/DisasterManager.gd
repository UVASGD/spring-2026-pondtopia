extends Node

const FLOOD_CHANCE = 0.5

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
			pass
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
			 
