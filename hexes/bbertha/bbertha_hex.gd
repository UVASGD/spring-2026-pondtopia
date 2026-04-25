extends BaseHex
class_name BBerthaHex

#TODO: change this number if we decide upon a tile requirement
const DEFENSE_REQUIREMENT : int = 0
const DEFENSE_RANGE : int = 1
var defense : bool = false


func on_added_to_map(_type: CREATE_TYPE, _extra_params : Array):
	# cost
	GameInfo.num_flies -= 5000
	on_added_to_map_base(_type, _extra_params)
	var contiguous_dam : Array[BaseHex] = await find_touching_berthas()
	if contiguous_dam.size() >= DEFENSE_REQUIREMENT:
		for i : BBerthaHex in contiguous_dam:
			i.defense = true
			#prints(i,"defense true: ",i.defense)

#looking for dams (to check for defense stuff)
func find_touching_berthas() -> Array[BaseHex]:
	var continguous_dam : Array[BaseHex] = await HexManager.get_contiguous_conditional(self.data.grid_coords,func(hex): return (hex is BBerthaHex))
	#prints("dams: ",continguous_dam)
	return continguous_dam

#calculated number of hexes underneath a hex (a line downwards) bounded by level radius
#equation : level_radius + self.grid_coords.y - (center of level coords.y) if self.grid_coords.x > 0
# level_radius + self.grid_coords. y - (center of level coords.y) + self.grid_coords.x if self.grid_coords.x < 0

#sending defense from flood
func send_defend_tiles() -> Array[BaseHex]:
	var defended_tiles : Array[BaseHex] = []
	#prints("grid_coords: ",self.data.grid_coords)
	if defense:
		defended_tiles = [self]
		var check_tiles : Array[BaseHex] = self.get_hexes_within(DEFENSE_RANGE)
		for i in check_tiles:
			if i.get_script().get_global_name() != "":
				defended_tiles.append(i)
				
	#TODO: delete when done testing
	for i : BaseHex in defended_tiles:
		i.sprites.rotate(PI/4)
	return defended_tiles

func tick():
	#TODO: delete when done testing
	send_defend_tiles()

#running check to see if any connected dam tiles need to be "untriggered"
func on_removed_from_map(_type: BaseHex.REMOVE_TYPE,_extra_params : Array):
	var contiguous_berthas : Array[BaseHex] = await find_touching_berthas()
	if contiguous_berthas.size() <= DEFENSE_REQUIREMENT:
		for i : BBerthaHex in contiguous_berthas:
			i.defense = false
			#prints(i,"defense false:",i.defense)
	queue_free()
