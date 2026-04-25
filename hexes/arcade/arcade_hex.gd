extends BaseHex
class_name ArcadeHex

func on_added_to_map(_type: CREATE_TYPE, _extra_params : Array):
	on_added_to_map_base(_type, _extra_params)


## There must be at least one house tile adjacent to the arcade
func check_house_nearby() -> bool:
	var nearby_hexes = self.get_adjacent_hexes()
	if nearby_hexes.size() == 0:
		return false
	for hex in nearby_hexes:
		if hex.hex_category == HexManager.HexCategory.HOUSING:
			return true
	return false
