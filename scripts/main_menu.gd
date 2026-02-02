extends Node
@onready var new_game: Button = $"Main/VBoxContainer/HBoxContainer/ButtonsContainer/New Game"
@onready var continue_button: Button = $Main/VBoxContainer/HBoxContainer/ButtonsContainer/Continue
@onready var options: Button = $Main/VBoxContainer/HBoxContainer/ButtonsContainer/Options
@onready var quit: Button = $Main/VBoxContainer/HBoxContainer/ButtonsContainer/Quit

func _on_new_game_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
