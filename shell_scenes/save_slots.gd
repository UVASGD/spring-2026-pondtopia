extends Control

@onready var buttons = [$VBoxContainer/HBoxContainer/ButtonsContainer/Save1, $VBoxContainer/HBoxContainer/ButtonsContainer/Save2, $VBoxContainer/HBoxContainer/ButtonsContainer/Save3]
@onready var test = $VBoxContainer/HBoxContainer/ButtonsContainer/Save1
@onready var cont = $VBoxContainer/HBoxContainer/RightBox/Continue
@onready var newSave = $VBoxContainer/HBoxContainer/RightBox/NewSave
@onready var img = $VBoxContainer/HBoxContainer/RightBox/FrogImg

var names : Array
var states : Array[bool] = [false, false, false]
var cur_pressed = -1

func _ready() -> void:
	#for i in 5 : SaveManager.delete_save(i)
	
	names = SaveManager.load_city_names()
	
	for i in range(3): 
		if typeof(names[i]) == 28:
			states[i] = true
			buttons[i].text = names[i][0]
		else:
			buttons[i].text = names[i]

func button_toggled(pressed : bool, num : int) : 
	if pressed:
		img.hide()
		if cur_pressed != -1 : buttons[cur_pressed].set_pressed_no_signal(false)
		cur_pressed = num
		if states[num]:
			newSave.hide()
			cont.show()
			
			cont.get_node("Title").text = str(names[num][0])
			cont.get_node("GridContainer/DayNum").text = str(names[num][1])
			cont.get_node("GridContainer/FlyNum").text = str(names[num][2])
		else:
			cont.hide()
			newSave.show()
	else:
		cur_pressed = -1
		newSave.hide()
		cont.hide()
		img.show()

func on_play_pressed() :
	switch_scene_()
	SignalBus.emit_signal("start_game_pressed", [cur_pressed])

func switch_scene_() :
	ShellSceneManager.close_overlay_panel()
	ShellSceneManager.switch_active_scene(Ref.get("game"))
	return

func delete_save():
	states[cur_pressed] = false
	names[cur_pressed] = "Save " + str(cur_pressed + 1)
	buttons[cur_pressed].text = names[cur_pressed]
	cont.hide()
	newSave.show()
	
	SaveManager.delete_save(cur_pressed)
