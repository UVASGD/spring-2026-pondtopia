extends Control

@onready var panel : Panel = $BuildingPopupPanel
@onready var build_button : TextureButton = $BuildingPopupPanel/BuildButton

const COLLAPSED_SIZE = Vector2(0, 0)
const EXPANDED_SIZE = Vector2(200, 400)
const TWEEN_DURATION = 0.5

var is_expanded = false

func _ready() -> void:
	panel.grow_horizontal = Control.GROW_DIRECTION_BEGIN
	panel.grow_vertical = Control.GROW_DIRECTION_BEGIN


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
	tween.tween_property(panel, "size", new_size, TWEEN_DURATION)
	tween.tween_callback(panel.queue_free)
	
