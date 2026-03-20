extends Control

@onready var buttons = [$VBoxContainer/HBoxContainer/ButtonsContainer/Save1, $VBoxContainer/HBoxContainer/ButtonsContainer/Save2, $VBoxContainer/HBoxContainer/ButtonsContainer/Save3]
var names : Array[String]

func _ready() -> void:
	names = SaveManager.load_city_names()
	
	for i in range(3): buttons[i].text = names[i]
