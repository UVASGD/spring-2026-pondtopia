extends BaseHex
class_name HouseHex

const FROG_CAP_INCREASE:int = 5
var frogs_moved_out:bool = false

func on_added_to_map(_type: CREATE_TYPE, _extra_params : Array):
	on_added_to_map_base(_type, _extra_params)
	GameInfo.frog_capacity += FROG_CAP_INCREASE


## Check for adjacent work tiles
func nearby_work_hexes() -> bool:
	var nearby_hexes = self.get_adjacent_hexes()
	if nearby_hexes.size() == 0:
		return false
	for hex in nearby_hexes:
		if hex.hex_category == HexManager.HexCategory.WORK:
			return true
	return false


## If there are work tiles nearby the frogs move out
func tick():
	if !nearby_work_hexes():
		return
	if frogs_moved_out:
		return
	GameInfo.frog_capacity -= FROG_CAP_INCREASE
