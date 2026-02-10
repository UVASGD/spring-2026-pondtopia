extends Node2D
class_name BaseHex

## BaseHex is a template for other hexes (all other hexes should extend this class).
## Override these methods to give other types of hexes different behavior.

### To properly extend BaseHex
## 1. Create a folder in the Hexes folder called example.
## 2. Create the scene.
##   a) Create a Node2D scene in that folder called example_hex.tscn.
##   b) Add a Node2D as a child of root. Rename it Sprites. Optional: Add Sprite2D nodes as children of that node.
##   b) Instantiate a HexOptions scene as a child of root (either by dragging in the file or via the link button). This is the cicle menu that pops up when you select a hex.
##   c) Optional: Open base_hex.tscn, copy the HexBoundsMarkers node, and paste it in example_hex.tscn.
## 3. Create the script.
##   a) Open example_hex.tscn and create a script on the root node called example_hex.gd. (Make sure the script is also in the folder).
##   b) In the script change "extends Node2D" to "extends BaseHex".
##   c) Below that line add "class_name ExampleHex".
## 4. Open HexManager.gd, find the list of hex packed scene vars and add a new line "var EXAMPLE_HEX : PackedScene = load("res://hexes/example/example_hex.tscn")".
## 5. You're done! To create special behaviors for your hex, override the functions in base hex (eg tick()). Remember to call the base behavior functions (eg tick_base()) if you want the overriden functions to also do the base functionality. 

## Directions (using Vector2 instead of enum so you can add with them, also declared in HexManager for easy access)
const NW := Vector2i(-1,1)
const NORTH := Vector2i(0,1)
const NE := Vector2i(1,0)
const SE := Vector2i(1,-1)
const SOUTH := Vector2i(0,-1)
const SW := Vector2i(-1,0)

## Create/move/remove types (allows for different animations on create move and remove)
enum CREATE_TYPE {
	INSTANT,FADE_IN
}
enum MOVE_TYPE {
	INSTANT,SLIDE
}
enum REMOVE_TYPE {
	INSTANT,FADE_OUT
}

## A unique id set by the HexManager when the hex is created
var debug_id

## Whether this hex is currently selected. Automatically set by HexManager.
var _is_selected : bool = false
## Whether this hex is currently highlighted. Automatically set by HexManager.
var _is_highlighted : bool = false

## The node that handles the circle popup menu.
@onready var hex_options : HexOptions = $HexOptions
## This node holds the sprites that make up the hex.
@onready var sprites : Node2D = $Sprites
## This resource holds all of the hex data.
@onready var data : HexData = HexData.new()

## Intended for overriding!
## Calling ready in extended versions of BaseHex will override this function. Make sure to call ready_base().
func _ready() -> void:
	ready_base()

## Intended for overriding!
## This function is automatically called every HexManager.tick_duration seconds.
## We could break tick into more calls in HexManager (eg generate_resources(), resolve_damage(), act_on_neighbors()) for more consistent behavior.
func tick() :
	tick_base()

## Intended for overriding!
## This function is automatically called when this hex is selected.
func on_selected() :
	on_selected_base()

## Intended for overriding!
## This function is automatically called when this hex is deselected.
func on_deselected() :
	on_deselected_base()

## Intended for overriding!
## This function is automatically called when this hex is selected.
func on_highlighted() :
	on_highlighted_base()

## Intended for overriding!
## This function is automatically called when this hex is deselected.
func on_unhighlighted() :
	on_unhighlighted_base()
#
### Intended for overriding!
### This function is automatically called when one of this hex's HexOptions buttons is pressed.
func on_hex_options_button_pressed(button_action_name : String) :
	on_hex_options_button_pressed_base(button_action_name)

## Intended for overriding!
## This function is automatically called when the hex is created and added to the map.
func on_added_to_map(_type: CREATE_TYPE, _extra_params : Array) :
	on_added_to_map_base(_type)

## Intended for overriding!
## This function is automatically called when the hex is moved from one grid spot to another.
func on_moved(_type: MOVE_TYPE, _extra_params : Array) :
	on_moved_base(_type)

## Intended for overriding! (Don't forget to queue_free at the end though)
## This function is automatically called when the hex is about to be removed from the map and queue_freed.
## Although this hex will not hold the grid spot anymore, the hex's nodes can stay in the same real position to do disappear animations etc.
func on_removed_from_map(_type: REMOVE_TYPE, _extra_params : Array) :
	on_removed_from_map_base(_type)

#region Base Behaviors

func ready_base() :
	hex_options.hide()

func tick_base() :
	pass

func on_selected_base() :
	sprites.modulate.b = 0
	sprites.modulate.r = 0
	hex_options.show()

func on_deselected_base() :
	sprites.modulate.b = 1
	sprites.modulate.r = 1
	hex_options.hide()

func on_highlighted_base() :
	sprites.modulate.a = 0.5

func on_unhighlighted_base() :
	sprites.modulate.a = 1

func on_hex_options_button_pressed_base(button_action_name : String) :
	match button_action_name :
		"delete":
			try_deselect()
			remove_from_map(REMOVE_TYPE.FADE_OUT)
		"clear":
			try_deselect()
			remove_from_map()
			HexManager.create_hex(data.grid_coords, HexManager.MIGRATED_HEX, CREATE_TYPE.INSTANT, [1])

func on_added_to_map_base(_type: CREATE_TYPE) :
	match _type :
		CREATE_TYPE.INSTANT :
			position = real_pos()
		CREATE_TYPE.FADE_IN :
			modulate.a = 0
			position = real_pos()
			#fade in
			var tween = create_tween()
			tween.tween_property(self, "modulate:a", 1, 0.8)
		_ : #default, do same as instant
			position = real_pos()

func on_moved_base(_type: MOVE_TYPE) :
	match _type :
		MOVE_TYPE.INSTANT :
			position = real_pos()
		MOVE_TYPE.SLIDE :
			var tween = create_tween()
			tween.tween_property(self, "position", real_pos(), 0.8)
		_ : #default, do same as instant
			position = real_pos()

func on_removed_from_map_base(_type: REMOVE_TYPE) :
	match _type :
		REMOVE_TYPE.INSTANT :
			queue_free()
		REMOVE_TYPE.FADE_OUT :
			var tween = create_tween()
			tween.tween_property(self, "modulate:a", 0, 0.8)
			queue_free()
		_ : #default, do same as instant
			queue_free()

#endregion

#region Utils
## Don't change or override these functions.

## Do not override.
func move(new_grid_coords: Vector2i, type: MOVE_TYPE = MOVE_TYPE.INSTANT) :
	HexManager.move_hex(self,new_grid_coords,type)

## Do not override.
func move_(new_x: int, new_y: int, type: MOVE_TYPE = MOVE_TYPE.INSTANT) :
	move(Vector2i(new_x,new_y),type)

## Do not override.
func remove_from_map(type: REMOVE_TYPE = REMOVE_TYPE.INSTANT) :
	HexManager.remove_hex(self,type)

## Do not override.
func real_pos() -> Vector2:
	return HexManager.get_associated_real_position(data.grid_coords)

## Do not override. Gets the hex at the grid spot self.grid_coords + relative_grid_coords.
func get_hex_rel(relative_grid_coords: Vector2i) -> BaseHex:
	return HexManager.get_hex_relative_to(data.grid_coords, relative_grid_coords)

## Do not override.
func get_hexes_rel(relative_grid_coords_list : Array) -> Array[BaseHex]:
	return HexManager.get_hexes_relative_to(data.grid_coords,relative_grid_coords_list)

## Do not override.
func get_coords_within(radius:int) -> Array[Vector2i]:
	return HexManager.get_coords_in_hexagon(radius,data.grid_coords)

## Do not override.
func get_hexes_within(radius:int) -> Array[BaseHex]:
	return HexManager.get_hexes_in_hexagon(radius,data.grid_coords)

## Do not override.
func nth_nearest_neighbors_coords(n:int) -> Array[Vector2i]:
	return HexManager.get_nth_nearest_neighbors_coords(n,data.grid_coords)

## Do not override.
func nth_nearest_neighbors(n:int) -> Array[BaseHex]:
	return HexManager.get_nth_nearest_neighbors_hexes(n,data.grid_coords)

## Do not override.
func get_adjacent_coords() -> Array[Vector2i]:
	return HexManager.get_adjacent_coords(data.grid_coords)

## Do not override.
func get_adjacent_hexes() -> Array[BaseHex]:
	return HexManager.get_adjacent_hexes(data.grid_coords)

## Do not override. Returns true if target_grid_coords are up to or including n spaces away.
func is_within(target_grid_coords: Vector2i, n:int) -> bool:
	return nearest_neighbor_dist(target_grid_coords) <= n

## Do not override.
func is_hex_within(target_hex:BaseHex, n:int) -> bool:
	return is_within(target_hex.data.grid_coords, n)

## Do not override. Returns what level of nearest neighbor the grid coords are (an adjacent tile returns 1).
func nearest_neighbor_dist(target_grid_coords: Vector2i) -> int:
	return HexManager.nearest_neighbor_dist(data.grid_coords, target_grid_coords)

## Do not override.
func nearest_neighbor_dist_(target_hex: BaseHex) -> int:
	return nearest_neighbor_dist(target_hex.data.grid_coords)

## Do not override.
func is_selected() -> bool :
	return _is_selected

## Do not override.
func select() :
	HexManager.select_hex(self)

## Do not override.
func try_deselect() :
	HexManager.try_deselect_hex(self)

## Do not override.
func is_highlighted() -> bool :
	return _is_highlighted

## Do not override.
func highlight() :
	if _is_highlighted : return
	_is_highlighted = true
	on_highlighted()

## Do not override.
func unhighlight() :
	if not _is_highlighted : return
	_is_highlighted = false
	on_unhighlighted()

#endregion
