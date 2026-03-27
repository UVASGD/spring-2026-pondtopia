extends VBoxContainer

func _on_button_toggled(toggled_on: bool, building_tile: String) -> void:
	if toggled_on:
		GameInfo.cur_selected_tile = building_tile
		print(GameInfo.cur_selected_tile)
