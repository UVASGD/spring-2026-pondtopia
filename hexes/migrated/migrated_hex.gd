extends BaseHex
class_name MigratedHex

## This hex is temporary so we can migrate the stuff from the old system over.

func on_added_to_map(_type: CREATE_TYPE, _extra_params : Variant):
	$Sprite2D.frame = randi_range(0,3)
	on_added_to_map_base(_type)
