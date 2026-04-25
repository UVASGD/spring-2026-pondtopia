extends BaseHex
class_name FruitHex

enum TYPE {
	ORANGE, STRAWBERRY, PEAR, BANANA
}

var type : TYPE
var params : Array

func on_added_to_map(_type: CREATE_TYPE, _extra_params : Array):
	print("Fruit Hex params: ", _extra_params)
	params = _extra_params
	if _extra_params.size() == 0 :
		set_type(TYPE.ORANGE)
	else :
		match _extra_params :
			"orange" :
				set_type(TYPE.ORANGE)
			"strawberry" :
				set_type(TYPE.STRAWBERRY)
			"pear" :
				set_type(TYPE.PEAR)
			"banana" :
				set_type(TYPE.BANANA)
		if _extra_params[0] is int :
			set_type(_extra_params[0] as TYPE)
	on_added_to_map_base(_type, _extra_params)

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

func set_type(t : TYPE) :
	print("Setting type to ", t)
	match t :
		TYPE.ORANGE :
			$Sprites/FruitSprite.frame = 0
			type = TYPE.ORANGE
		TYPE.STRAWBERRY :
			$Sprites/FruitSprite.frame = 1
			type = TYPE.STRAWBERRY
		TYPE.PEAR :
			$Sprites/FruitSprite.frame = 2
			type = TYPE.PEAR
		TYPE.BANANA :
			$Sprites/FruitSprite.frame = 3
			type = TYPE.BANANA
