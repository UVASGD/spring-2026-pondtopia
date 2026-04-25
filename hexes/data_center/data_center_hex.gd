extends BaseHex
class_name DataCenterHex

var NOT_NEIGHBORS : Array = ["BaseHex", "FruitHex", "MigratedHex"]

const COST : int = 100
const INCOME : int = 50



func on_added_to_map(_type: CREATE_TYPE, _extra_params : Array):
	GameInfo.num_flies -= COST
	on_added_to_map_base(_type, _extra_params)



func tick():
	if (not _has_neighbors()):
		GameInfo.num_flies += INCOME



func _has_neighbors() -> bool:
	var neighbors = HexManager.get_hexes_in_hexagon(1, Vector2.ZERO, true)
	for neighbor in neighbors:
		var neighbor_type = neighbor.get_script().get_global_name()
		if (NOT_NEIGHBORS.has(neighbor_type) == false):
			return true
	return false
