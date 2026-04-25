extends BaseHex
class_name StumpHouseHex

const FROG_CAP_INCREASE:int = 7

func on_added_to_map(_type: CREATE_TYPE, _extra_params : Array):
	on_added_to_map_base(_type, _extra_params)
	GameInfo.frog_capacity += FROG_CAP_INCREASE
