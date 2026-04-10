extends Node

const FLOOD_CHANCE = 0.3 #randf()

func smite_those_frogs(cur_disaster: String):
	match cur_disaster:
		"flood":
			for hex in HexManager.hex_list:
				#hex.send_defend_tiles()
				print(hex.get_script().get_global_name())
				if randf() < FLOOD_CHANCE: #destroy it
					pass
				
		"fire":
			pass
		"earthquake":
			pass
		"meteor":
			pass
