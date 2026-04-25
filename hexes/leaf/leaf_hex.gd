extends BaseHex
class_name LeafHex

var defended_tiles : Array[BaseHex] = []

func on_added_to_map(_type: CREATE_TYPE, _extra_params : Array):
	# cost
	GameInfo.num_flies -= 100
	on_added_to_map_base(_type, _extra_params)

# sending defense from earthquake
func send_defend_tiles() -> Array[BaseHex]:
	#prints("grid_coords: ", self.data.grid_coords)
	defended_tiles = [self]
	for hex in self.get_adjacent_hexes():
		defended_tiles.append(hex)
	#print(defended_tiles)
	return defended_tiles

#func tick():
	#for i : BaseHex in defended_tiles:
		#i.sprites.rotate(PI/4)
