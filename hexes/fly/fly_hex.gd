extends BaseHex
class_name FlyHex

const FLIES_ADDED:int = 25

func on_added_to_map(_type: CREATE_TYPE, _extra_params : Array):
	# cost
	GameInfo.num_flies -= 100
	on_added_to_map_base(_type, _extra_params)

func tick():
	GameInfo.num_flies += FLIES_ADDED
