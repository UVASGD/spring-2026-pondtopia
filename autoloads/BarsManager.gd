extends Node

#handles happiness and whatever other bars we need
signal happyUpdate(value : int)
signal energyUpdate(value : int)

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
	var newhappy : int = int(max(0,min(100,50+((30*c[0])-(10*c[1] + 5*c[2])))))
	if GameInfo.happiness != newhappy:
		print(newhappy)
		GameInfo.happiness = newhappy
		happyUpdate.emit(newhappy)

# e = 10*W - Energy sapping buildings
func updateEnergy():
	var allhexes : Array[BaseHex] = HexManager.get_hexes_in_hexagon(GameInfo.level_radius)
	var newenergy : int = 0
	for i in allhexes:
		if i.hex_category == HexManager.HexCategory.WORK:
			newenergy += 10
		newenergy -= i.data.energy_cost
	clampi(newenergy,0,100)
	if GameInfo.energy != newenergy:
		print(newenergy)
		GameInfo.happiness = newenergy
		energyUpdate.emit(newenergy)
