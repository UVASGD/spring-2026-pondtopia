extends VBoxContainer

func _on_button_toggled(toggled_on: bool, building_tile: String) -> void:
	var cur_building_name = building_tile.capitalize() + "Button"
	for button in get_children():
		if (button.name != cur_building_name):
			button.set_pressed_no_signal(false)
	if toggled_on:
		var sendtype : HexManager.HexType = HexManager.HexType.BASEHEX
		match building_tile:
			"fly":
				sendtype = HexManager.HexType.FLYHEX
			"flower":
				sendtype = HexManager.HexType.FLOWERHEX
			"house":
				sendtype = HexManager.HexType.HOUSEHEX
			"dam":
				sendtype = HexManager.HexType.DAMHEX
			"bbertha":
				sendtype = HexManager.HexType.BBERTHAHEX
		GameInfo.cur_selected_tile = sendtype
		print(GameInfo.cur_selected_tile)
	else:
		GameInfo.cur_selected_tile = HexManager.HexType.BASEHEX
