extends VBoxContainer

func _on_button_toggled(toggled_on: bool, building_tile: String) -> void:
	var cur_building_name = building_tile.capitalize() + "Button"
	for button in get_children():
		if (button.name != cur_building_name):
			button.set_pressed_no_signal(false)
	
	if toggled_on:
		GameInfo.cur_selected_tile = building_tile
