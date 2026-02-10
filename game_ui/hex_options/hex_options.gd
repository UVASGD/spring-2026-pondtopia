extends Control
class_name HexOptions

const button_dict : Dictionary = {
	"delete" = preload("res://game_ui/hex_options/buttons/hob_delete.tscn"),
	"clear" = preload("res://game_ui/hex_options/buttons/hob_clear.tscn"),
	"fly" = preload("res://hexes/fly/fly_hex.tscn"),
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
