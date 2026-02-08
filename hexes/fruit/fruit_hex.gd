extends BaseHex
class_name FruitHex

enum TYPE {
	ORANGE, STRAWBERRY, PEAR, BANANA
}

var type : TYPE

func on_added_to_map(_type: CREATE_TYPE, _extra_params : Variant):
	match _extra_params :
		"orange" :
			$FruitSprite.frame = 0
			type = TYPE.ORANGE
		"strawberry" :
			$FruitSprite.frame = 1
			type = TYPE.STRAWBERRY
		"pear" :
			$FruitSprite.frame = 2
			type = TYPE.PEAR
		"banana" :
			$FruitSprite.frame = 3
			type = TYPE.BANANA
	if _extra_params is int :
		$FruitSprite.frame = _extra_params
		type = _extra_params
	on_added_to_map_base(_type)

func on_selected():
	var a : Array[BaseHex] = []
	match type : 
		TYPE.ORANGE :
			a = get_hexes_rel([NORTH])
		TYPE.STRAWBERRY :
			a = get_hexes_rel([SOUTH])
		TYPE.PEAR :
			a = get_hexes_rel([SE, NE])
		TYPE.BANANA :
			a = get_hexes_rel([NW, SW])
	for hex in a :
		hex.highlight()
	on_selected_base()

func on_deselected():
	for hex in get_adjacent_hexes() :
		hex.unhighlight()
	on_deselected_base()
