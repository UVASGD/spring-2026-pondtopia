extends BaseHex
class_name FlyHex

const COST : int = 100
const INCOME : int = 25



func on_added_to_map(_type: CREATE_TYPE, _extra_params : Array):
	GameInfo.num_flies -= COST
	on_added_to_map_base(_type, _extra_params)



func tick():
	GameInfo.num_flies += INCOME
