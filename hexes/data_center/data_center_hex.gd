extends BaseHex
class_name DataCenterHex

const COST : int = 100
const INCOME : int = 100



func on_added_to_map(_type: CREATE_TYPE, _extra_params : Array):
	GameInfo.num_flies -= COST
	on_added_to_map_base(_type, _extra_params)



func tick():
	GameInfo.num_flies += INCOME



"""
func _has_neighbors() -> bool:
	var neighbors = HexManager.get_hexes_in_hexagon(1, Vector2.ZERO, true)
	for neighbor in neighbors:
		print(neighbor.get_class())
		if (neighbor.get_class() != "Node2D"):
			return true
	return false
"""
