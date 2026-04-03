extends Control

@onready var continue_button : Button = $TextureRect/VBoxContainer/HBoxContainer/ButtonsContainer/Continue


func _ready() -> void:
	continue_button.pressed.connect(on_continue_pressed)


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		show()
		
func on_continue_pressed() -> void:
	hide()
