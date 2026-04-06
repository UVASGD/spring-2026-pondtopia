extends Control
class_name HexOptions

## HexOptions
## This script works with the buttons in the menu that opens when you select a hex.
## It handles the communication between the buttons and the hex (so you don't have to deal with the on_pressed signals and allows you to add and remove buttons to the menu.

## Proper way to add a new button to the hex options menu.
## 1) Create the button scene.
##   a) Create a new scene in the game_ui/hex_options/buttons folder.
##     i) Name the scene hob_example (hob stands for hex options button).
##     ii) The root node can be any type but it should not be a Button.
##   b) Add a Button as a child of the root node.
##   c) Add the hex_options_button.gd script to the root node.
##   d) In the inspector on the root node, fill out the export field action_name (eg "delete" or "upgrade")
##   e) Open hex_options.gd (this script) and add a line to button_dict with the preloaded scene and the action_name as the key.
##   f) Optional: Open hex_options.tscn and add an instance of the button scene as a child of the CircleContainer node. (This will make the button show up in all hex's popup menus as opposed to only adding the button to specific menus at runtime). 
## 2) Implement what happens when the button is pressed.
##   a) There is a function on_hex_options_button_pressed(button_action_name) in BaseHex. It calls on_hex_options_button_pressed_base(button_action_name).
##   b) You can implement the behavior by changing something on_hex_options_button_pressed_base() or by overriding on_hex_options_button_pressed() in a extension of BaseHex.
##   c) The button_action_name will be the string you entered into the hex_options_button.gd action_name field.
##   d) Remember that when overriding on_hex_options_button_pressed, on_hex_options_button_pressed_base will not be called unless you call it in the override.
## 3) You're done! To edit what buttons are in a HexOptions menu at runtime, use the functions in this script (add_button(), remove_button(), etc).

const button_dict : Dictionary = {
	"delete" = preload("res://game_ui/hex_options/buttons/hob_delete.tscn"),
	"clear" = preload("res://game_ui/hex_options/buttons/hob_clear.tscn"),
	"fly" = preload("res://hexes/fly/fly_hex.tscn"),
	"dam" = preload("res://game_ui/hex_options/buttons/hob_dam.tscn")
}

var hex : BaseHex

@onready var buttons = $CircleContainer

func _ready() -> void:
	hex = get_parent()

func add_button(button_scene : PackedScene) :
	var b = button_scene.instantiate()
	assert(b is HexOptionsButton)
	buttons.add_child(b)

func has_button(button_action_name : String) -> bool :
	for c in get_children() :
		if c.action_name == button_action_name :
			return true
	return false

func get_button(button_action_name : String) -> HexOptionsButton :
	for c in get_children() :
		if c.action_name == button_action_name :
			return c
	return null

func remove_button(button_action_name : String) :
	for c in get_children() :
		if c.action_name == button_action_name :
			buttons.remove_child(c)
			return

func _on_button_pressed(button_action_name : String) :
	hex.on_hex_options_button_pressed(button_action_name)
