extends BaseHex
class_name HousingHex

func get_frogs_required() -> int:
	return 5

func on_added_to_map(_type: CREATE_TYPE, _extra_params: Array):
	if _extra_params.size() == 0:
		$Sprites/Sprite2D.frame = randi_range(0,3)
	else:
		$Sprites/Sprite2D.frame = _extra_params[0]
	on_added_to_map_base(_type, _extra_params)
