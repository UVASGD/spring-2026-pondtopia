extends BaseHex
class_name SoupHex

const FLIES_ADDED:int = 25

func on_added_to_map(_type: CREATE_TYPE, _extra_params : Array):
	on_added_to_map_base(_type, _extra_params)


func tick():
	if !nearby_decor_tiles():
		return
	GameInfo.num_flies += FLIES_ADDED


func nearby_decor_tiles() -> bool:
	if !self.has_neighbors():
		return false
	var decor_count:int = 0
	for hex in self.get_adjacent_hexes():
		if hex.data.hextype == HexManager.HexCategory.DECORATION:
			decor_count += 1
	if decor_count < 1 or decor_count > 3:
		print("SOUP: Number of nearby decor tiles <1 or >3. Cannot place")
		return false
	return true
