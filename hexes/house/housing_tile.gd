extends BaseHex
class_name HousingTile

const FROG_CAP_INCREASE:int = 5

func on_added_to_map(_type: CREATE_TYPE, _extra_params : Array):
	# cost
	GameInfo.num_flies -= 100
	on_added_to_map_base(_type, _extra_params)
	GameInfo.frog_capacity += FROG_CAP_INCREASE

#func tick():
	#GameInfo.frog_capacity += FROG_CAP_INCREASE
