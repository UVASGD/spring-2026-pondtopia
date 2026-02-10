extends Control
class_name HexOptionsButton

@export var action_name : String

var hex_options : HexOptions

@onready var button : Button = $Button

func _ready() -> void:
	hex_options = get_parent().get_parent()
	button.pressed.connect(_on_pressed)

func _on_pressed() :
	hex_options._on_button_pressed(action_name)
