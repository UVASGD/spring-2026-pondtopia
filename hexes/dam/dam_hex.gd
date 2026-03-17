extends BaseHex
class_name DamHex

#how many tiles this protects in a southern line
const DEFENSE_RANGE : int = 3
#how many dam tiles needed for it to function
const DEFENSE_REQUIREMENT : int = 3 
#determi
var defense : bool = false

func on_added_to_map(_type: CREATE_TYPE, _extra_params : Array):
	# cost
	GameInfo.num_flies -= 100
	on_added_to_map_base(_type, _extra_params)
	var contiguous_dam : Array[BaseHex] = await find_touching_dams()
	if contiguous_dam.size() >= DEFENSE_REQUIREMENT:
		for i : DamHex in contiguous_dam:
			i.defense = true
			prints(i,"defense true: ",i.defense)

#looking for dams (to check for defense stuff)
func find_touching_dams() -> Array[BaseHex]:
	var continguous_dam : Array[BaseHex] = await HexManager.get_contiguous_conditional(self.data.grid_coords,func(hex): return (hex is DamHex))
	prints("dams: ",continguous_dam)
	return continguous_dam

#sending defense from flood
func send_defend_tiles() -> Array[BaseHex]:
	var defended_tiles : Array[BaseHex] = []
	if defense:
		defended_tiles = [self]
		var southward : Vector2 = Vector2.ZERO
		for i in DEFENSE_RANGE:
			southward += HexManager.SOUTH
			defended_tiles.append(get_hex_rel(southward))
	
	for i : BaseHex in defended_tiles:
		i.sprites.rotate(PI/4)
	
	return defended_tiles

func tick():
	send_defend_tiles()

#running check to see if any connected dam tiles need to be "untriggered"
func on_removed_from_map(_type: BaseHex.REMOVE_TYPE,_extra_params : Array):
	var contiguous_dam : Array[BaseHex] = await find_touching_dams()
	if contiguous_dam.size() <= DEFENSE_REQUIREMENT:
		for i : DamHex in contiguous_dam:
			i.defense = false
			prints(i,"defense false:",i.defense)
	queue_free()
