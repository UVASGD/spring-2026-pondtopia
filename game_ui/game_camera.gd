extends Camera2D

# --- Limits ---
@export var zoom_min : float = 0.5
@export var zoom_max : float = 5.0
@export var pan_bounds_rect : Rect2 = Rect2(-200,-200,400,400)

# --- Smooth zoom ---
var target_zoom : Vector2
@export var zoom_lerp_speed : float = 10.0

# --- Drag + inertia ---
var dragging := false
var last_mouse_pos := Vector2.ZERO
var velocity := Vector2.ZERO
@export var inertial : bool = false
@export var inertia_friction : float = 10.0   # higher = stops faster

func _ready() -> void:
	target_zoom = zoom

func _unhandled_input(event: InputEvent) -> void:
	# --- Right mouse drag ---
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			dragging = event.pressed
			last_mouse_pos = get_global_mouse_position()
			
		# --- Mouse wheel zoom ---
		if event.pressed:
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				_apply_zoom_step(0.9)
			elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				_apply_zoom_step(1.1)
				
	# --- Trackpad scroll zoom (smooth gesture) ---
	elif event is InputEventPanGesture:
		# vertical delta controls zoom
		var factor : float = 1.0 + event.delta.y * 0.01
		_apply_zoom_step(factor)
		
	# --- Dragging motion ---
	elif event is InputEventMouseMotion and dragging:
		var delta : Vector2 = get_global_mouse_position() - last_mouse_pos
		last_mouse_pos = get_global_mouse_position()
		
		velocity = -delta #* zoom.x  # store velocity for inertia
		position += velocity
		
		_clamp_position()

func _process(delta: float) -> void:
	# --- Smooth zoom interpolation ---
	zoom = zoom.lerp(target_zoom, zoom_lerp_speed * delta)
	
	# --- Inertia when not dragging ---
	if inertial and not dragging and velocity.length() > 0.1:
		position += velocity
		velocity = velocity.lerp(Vector2.ZERO, inertia_friction * delta)
		_clamp_position()

func _apply_zoom_step(mult: float) -> void:
	target_zoom *= mult
	target_zoom.x = clamp(target_zoom.x, zoom_min, zoom_max)
	target_zoom.y = clamp(target_zoom.y, zoom_min, zoom_max)

func _clamp_position() -> void:
	position.x = clamp(position.x, pan_bounds_rect.position.x, pan_bounds_rect.position.x + pan_bounds_rect.size.x)
	position.y = clamp(position.y, pan_bounds_rect.position.y, pan_bounds_rect.position.y + pan_bounds_rect.size.y)
