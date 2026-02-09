extends Node2D
class_name BaseHex

## BaseHex is a template for other hexes (all other hexes should extend this class).
## Override these methods to give other types of hexes different behavior.

### TO PROPERLY EXTEND BaseHex
## 1. Create a folder in the Hexes folder called example.
## 2. Create a Node2D scene in that folder called example_hex.tscn.
## 3. Open the scene and create a script on the root node called example_hex.gd. (Make sure the script is also in the folder).
## 4. In the script change "extends Node2D" to "extends BaseHex".
## 5. Below that line add "class_name ExampleHex".
## 6. Open base_hex.gd (this script), find the HEX_SCENES dictionary, and add an entry "EXAMPLE = preload("res://hexes/example/example_hex.tscn")".
## 7. You're done! To create special behaviors for your hex, override the functions in base hex (eg tick()). Remember to call the base behavior functions (eg tick_base()) if you want the overriden functions to also do the base functionality. 

## Directions (using Vector2 instead of enum so you can add with them, also declared in HexManager for easy access)
const NW := Vector2i(-1,1)
const NORTH := Vector2i(0,1)
const NE := Vector2i(1,0)
const SE := Vector2i(1,-1)
const SOUTH := Vector2i(0,-1)
const SW := Vector2i(-1,0)

## Preloaded hex scenes (allows HexManager to create different hexes by loading a different scene)
const HEX_SCENES : Dictionary = {
	BASE = preload("res://hexes/base/base_hex.tscn"),
	MIGRATED = preload("res://hexes/migrated/migrated_hex.tscn"),
	FRUIT = preload("res://hexes/fruit/fruit_hex.tscn")
}

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

## The coordinates of the spot on the map that this hex holds. The hex may not necessarily be at the associated real position.
var _grid_coords : Vector2i
## Whether this hex is currently selected. Automatically set by HexManager.
var _is_selected : bool = false
## Whether this hex is currently highlighted. Automatically set by HexManager.
var _is_highlighted : bool = false

@onready var sprites : Node2D = $Sprites

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

## Intended for overriding!
## This function is automatically called when the hex is created and added to the map.
func on_added_to_map(_type: CREATE_TYPE, _extra_params : Variant) :
	on_added_to_map_base(_type)

## Intended for overriding!
## This function is automatically called when the hex is moved from one grid spot to another.
func on_moved(_type: MOVE_TYPE, _extra_params : Variant) :
	on_moved_base(_type)

## Intended for overriding! (Don't forget to queue_free at the end though)
## This function is automatically called when the hex is about to be removed from the map and queue_freed.
## Although this hex will not hold the grid spot anymore, the hex's nodes can stay in the same real position to do disappear animations etc.
func on_removed_from_map(_type: REMOVE_TYPE, _extra_params : Variant) :
	on_removed_from_map_base(_type)

#region Base Behaviors

func tick_base() :
	pass

func on_selected_base() :
	sprites.modulate.b = 0
	sprites.modulate.r = 0

func on_deselected_base() :
	sprites.modulate.b = 1
	sprites.modulate.r = 1

func on_highlighted_base() :
	sprites.modulate.a = 0.5

func on_unhighlighted_base() :
	sprites.modulate.a = 1

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
	return HexManager.get_associated_real_position(_grid_coords)

## Do not override. Gets the hex at the grid spot self.grid_coords + relative_grid_coords.
func get_hex_rel(relative_grid_coords: Vector2i) -> BaseHex:
	return HexManager.get_hex_relative_to(_grid_coords, relative_grid_coords)

## Do not override.
func get_hexes_rel(relative_grid_coords_list : Array) -> Array[BaseHex]:
	return HexManager.get_hexes_relative_to(_grid_coords,relative_grid_coords_list)

## Do not override.
func get_coords_within(radius:int) -> Array[Vector2i]:
	return HexManager.get_coords_in_hexagon(radius,_grid_coords)

## Do not override.
func get_hexes_within(radius:int) -> Array[BaseHex]:
	return HexManager.get_hexes_in_hexagon(radius,_grid_coords)

## Do not override.
func nth_nearest_neighbors_coords(n:int) -> Array[Vector2i]:
	return HexManager.get_nth_nearest_neighbors_coords(n,_grid_coords)

## Do not override.
func nth_nearest_neighbors(n:int) -> Array[BaseHex]:
	return HexManager.get_nth_nearest_neighbors_hexes(n,_grid_coords)

## Do not override.
func get_adjacent_coords() -> Array[Vector2i]:
	return HexManager.get_adjacent_coords(_grid_coords)

## Do not override.
func get_adjacent_hexes() -> Array[BaseHex]:
	return HexManager.get_adjacent_hexes(_grid_coords)

## Do not override. Returns true if target_grid_coords are up to or including n spaces away.
func is_within(target_grid_coords: Vector2i, n:int) -> bool:
	return nearest_neighbor_dist(target_grid_coords) <= n

## Do not override.
func is_hex_within(target_hex:BaseHex, n:int) -> bool:
	return is_within(target_hex.grid_coords,n)

## Do not override. Returns what level of nearest neighbor the grid coords are (an adjacent tile returns 1).
func nearest_neighbor_dist(target_grid_coords: Vector2i) -> int:
	return HexManager.nearest_neighbor_dist(_grid_coords, target_grid_coords)

## Do not override.
func nearest_neighbor_dist_(target_hex: BaseHex) -> int:
	return nearest_neighbor_dist(target_hex.grid_coords)

## Do not override.
func is_selected() -> bool :
	return _is_selected

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
