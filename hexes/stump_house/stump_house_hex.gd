extends BaseHex
class_name StumpHouseHex

const FROG_CAP_INCREASE:int = 5

func on_added_to_map(_type: CREATE_TYPE, _extra_params : Array):
	on_added_to_map_base(_type, _extra_params)
	GameInfo.frog_capacity += FROG_CAP_INCREASE

#func tick():
	#GameInfo.frog_capacity += FROG_CAP_INCREASE
