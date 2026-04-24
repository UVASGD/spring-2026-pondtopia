extends Node

#handles happiness and whatever other bars we need

func updateHappy():
	var allhexes : Array[BaseHex] = HexManager.get_hexes_in_hexagon(GameInfo.level_radius)
	var c : Array[int] = [0,0,0,0] # decoration, work, housing, emergencies
	for i in allhexes:
		match i.hex_category:
			HexManager.HexCategory.DECORATION:
				c[0] += 1
			HexManager.HexCategory.WORK:
				c[1] += 1
			HexManager.HexCategory.HOUSING:
				c[2] += 1
			HexManager.HexCategory.EMERGENCY:
				c[3] += 1
	GameInfo.happiness = int(float(2*c[0])/float((2*c[1]+c[2]+(0.5*c[3]))))
