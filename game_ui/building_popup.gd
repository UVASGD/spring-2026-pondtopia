extends Control

@onready var panel : Panel = $BuildingPopupPanel

const COLLAPSED_SIZE = Vector2(1, 1)
const EXPANDED_SIZE = Vector2(2, 4)
const COLLAPSED_ROUNDING = 32
const EXPANDED_ROUNDING = 8
const TWEEN_DURATION = 0.5

var is_expanded = false

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	pass


func _on_build_button_pressed() -> void:
	is_expanded = !is_expanded
	_animate_panel(is_expanded)
	
	

func _animate_panel(expanding : bool) -> void:
	var tween = create_tween()
	
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUINT)
	
	var new_size = EXPANDED_SIZE if expanding else COLLAPSED_SIZE
	tween.tween_property(panel, "scale", new_size, TWEEN_DURATION)
	
	var new_rounding = EXPANDED_ROUNDING if expanding else COLLAPSED_ROUNDING
	panel.get_theme_stylebox("panel").set_corner_radius_all(new_rounding)
	
