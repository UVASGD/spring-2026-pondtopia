extends BaseHex
class_name LeafHex

var defended_tiles : Array[BaseHex] = []

func on_added_to_map(_type: CREATE_TYPE, _extra_params : Array):
	on_added_to_map_base(_type, _extra_params)

# sending defense from earthquake
func send_defend_tiles() -> Array[BaseHex]:
	defended_tiles = [self]
	for hex in self.get_adjacent_hexes():
		print(hex.data.grid_coords)
		defended_tiles.append(hex)
	return defended_tiles
