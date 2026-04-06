extends Control

@onready var continue_button : Button = $TextureRect/VBoxContainer/HBoxContainer/ButtonsContainer/Continue
@onready var options_menu : Control = $Options


func _ready() -> void:
	continue_button.pressed.connect(on_continue_pressed)
	options_menu.get_node("BackButton").pressed.connect(on_options_back_pressed)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		show()
		
func on_continue_pressed() -> void:
	hide()

func _on_options_pressed() -> void:
	options_menu.show()

func on_options_back_pressed() -> void:
	options_menu.hide()
