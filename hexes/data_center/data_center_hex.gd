extends BaseHex
class_name DataCenterHex

const FLIES_ADDED:int = 100

func on_added_to_map(_type: CREATE_TYPE, _extra_params : Array):
	on_added_to_map_base(_type, _extra_params)


func tick():
	if has_neighbors():
		return
	GameInfo.num_flies += FLIES_ADDED
