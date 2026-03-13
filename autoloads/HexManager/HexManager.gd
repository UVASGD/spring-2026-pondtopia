extends Node2D

### AUTOLOAD

### HexManager ###
## Manages the hexes and the hex map.

## Directions (using Vector2 instead of enum so you can add with them, also declared in BaseHex for easy access)
const NW = Vector2(-1,1)
const NORTH = Vector2(0,1)
const NE = Vector2(0,1)
const SE = Vector2(1,-1)
const SOUTH = Vector2(0,-1)
const SW = Vector2(-1,0)

## Preloaded hex packed scenes for instantiating hexes
## These should be preloaded constants but preloading them causes a cyclic error.
var BASE_HEX : PackedScene = load("res://hexes/base/base_hex.tscn")
var MIGRATED_HEX : PackedScene = load("res://hexes/migrated/migrated_hex.tscn")
var FRUIT_HEX : PackedScene = load("res://hexes/fruit/fruit_hex.tscn")
var FLY_HEX : PackedScene = load("res://hexes/fly/fly_hex.tscn")
var DAM_HEX : PackedScene = load("res://hexes/dam/dam_hex.tscn")

## When set to false, all methods in region Modify will be returned immediately
var _allow_modify_actions : bool = false

## Allows conversion between real and grid coordinates.
var grid = HexGrid.new(76)

## An array of all hexes on the map for easy iteration (as opposed to having to do difficult iteration through the map double dictionary).
var hex_list : Array[BaseHex] = []
## Stores the hexes based on their grid coordinates for easy access by coords.
var map : DoubleDict = DoubleDict.new()

## Selected Hex
var _selected_hex : BaseHex = null

# Other
var next_debug_id = 0

## Called by GameManager
## Could break tick into more calls (eg generate_resources(), resolve_damage(), act_on_neighbors()) for more consistent behavior.
func tick() :
	for hex in hex_list :
		hex.tick()

#region Access

## Returns true if there is a hex at grid_coords.
func is_hex_at(grid_coords: Vector2i) -> bool:
	return map.has_entryv(grid_coords)

## See is_hex_at().
func is_hex_at_(x:int,y:int) -> bool:
	return is_hex_at(Vector2i(x,y))

## Gets the hex at grid_coords.
func get_hex(grid_coords: Vector2i) -> BaseHex:
	return map.get_entryv(grid_coords)

## See get_hex().
func get_hex_(x:int,y:int) -> BaseHex:
	return get_hex(Vector2i(x,y))

## Like get_hex() but uses relative_to_hex as the origin.
func get_hex_relative(relative_to_hex: BaseHex, relative_grid_coords: Vector2i) -> BaseHex:
	return get_hex(relative_to_hex.data.grid_coords + relative_grid_coords)

## Like get_hex() but uses relative_to_coords as the origin.
func get_hex_relative_to(relative_to_coords: Vector2i, relative_grid_coords: Vector2i) -> BaseHex:
	return get_hex(relative_to_coords + relative_grid_coords)

## Like get_hex() but allows for multiple hexes.
func get_hexes(grid_coords_list: Array) -> Array[BaseHex]:
	#assert(grid_coords_list is Array[Vector2i])
	var output : Array[BaseHex] = []
	for c in grid_coords_list:
		if is_hex_at(c) :
			output.append(get_hex(c))
	return output

## Like get_hex_relative() but allows for multiple hexes.
func get_hexes_relative(relative_to_hex: BaseHex, relative_grid_coords_list: Array) -> Array[BaseHex]:
	return get_hexes_relative_to(relative_to_hex.data.grid_coords, relative_grid_coords_list)

## Like get_hex_relative_to() but allows for multiple hexes.
func get_hexes_relative_to(relative_to_coords: Vector2i, relative_grid_coords_list: Array) -> Array[BaseHex]:
	var grid_coords_list = relative_grid_coords_list.map(func(v): return v + relative_to_coords)
	return get_hexes(grid_coords_list)

## Returns the real position associated with grid_coords.
func get_associated_real_position(grid_coords: Vector2) -> Vector2:
	return grid.grid_to_realv(grid_coords)

#endregion

#region Modify

## Creates a hex grid_coords. If there is already there, throws an error. 
func create_hex(grid_coords: Vector2i, hex_scene : PackedScene, type: BaseHex.CREATE_TYPE = BaseHex.CREATE_TYPE.INSTANT, extra_params : Array = []) -> BaseHex:
	if not _allow_modify_actions :
		return null
	if map.has_entryv(grid_coords) :
		push_error("Tried to create a new hex at " + str(grid_coords) + " but a hex was already there.")
		return
	# instantiate
	var hex : BaseHex = hex_scene.instantiate()
	# set parent
	add_child(hex)
	# set debug id
	hex.debug_id = next_debug_id
	next_debug_id += 1
	# register
	_register_hex_at(hex, grid_coords)
	# call on_added_to_map for unique behavior
	hex.on_added_to_map(type, extra_params)
	return hex

## See create_hex().
func create_hex_(x:int,y:int, hex_scene : PackedScene, type: BaseHex.CREATE_TYPE = BaseHex.CREATE_TYPE.INSTANT, extra_params : Array = []) -> BaseHex:
	return create_hex(Vector2i(x,y), hex_scene, type, extra_params)

## Moves a hex from its current position to new_grid_coords.
func move_hex(hex: BaseHex, new_grid_coords: Vector2i, type: BaseHex.MOVE_TYPE = BaseHex.MOVE_TYPE.INSTANT, extra_params : Array = []):
	if not _allow_modify_actions :
		return null
	if map.has_entryv(new_grid_coords) :
		push_error("Tried to move a hex to " + str(new_grid_coords) + " but a hex was already there.")
		return
	_set_hex_position(hex, new_grid_coords)
	hex.on_moved(type, extra_params)

## See move_hex().
func move_hex_(hex: BaseHex, new_x: int, new_y: int, type: BaseHex.MOVE_TYPE = BaseHex.MOVE_TYPE.INSTANT, extra_params : Array = []) :
	move_hex(hex,Vector2i(new_x,new_y),type,extra_params)

## Moves the hex at old_grid_coords to new_grid_coords.
func move_hex_from(old_grid_coords: Vector2i, new_grid_coords: Vector2i, type: BaseHex.MOVE_TYPE = BaseHex.MOVE_TYPE.INSTANT, extra_params : Array = []):
	if map.has_entryv(old_grid_coords) :
		push_error("Tried to move a hex from " + str(new_grid_coords) + " but there was no hex there.")
		return
	move_hex(get_hex(old_grid_coords),new_grid_coords,type,extra_params)

## See move_hex_from().
func move_hex_from_(old_x:int,old_y:int,new_x:int,new_y:int,type: BaseHex.MOVE_TYPE = BaseHex.MOVE_TYPE.INSTANT, extra_params : Array = []):
	move_hex_from(Vector2i(old_x,old_y),Vector2i(new_x,new_y),type,extra_params)

## Removes and deletes the hex.
func remove_hex(hex: BaseHex, type: BaseHex.REMOVE_TYPE = BaseHex.REMOVE_TYPE.INSTANT, extra_params : Array = []):
	if not _allow_modify_actions :
		return null
	_unregister_hex(hex)
	hex.on_removed_from_map(type,extra_params)

func remove_all_hexes(type: BaseHex.REMOVE_TYPE = BaseHex.REMOVE_TYPE.INSTANT) :
	for i in hex_list.size() :
		hex_list[0].remove_from_map(type)

#endregion

#region Advanced

## Returns a list of coords of all of the grid points that are within a hexagon of radius radius around center.
## ie if radius = 3, this returns the first, second, and third nearest neighbors to center (optionally excluding center)
## List starts with the bottom spot of the leftmost column, proceeds up that column, then does the same for the next column to the right, and so on.
func get_coords_in_hexagon(radius: int, center: Vector2i = Vector2i.ZERO, exclude_center: bool = false) -> Array[Vector2i]:
	var a : Array[Vector2i] = []
	for i in range(-radius, radius+1) :
		for j in range(-radius, radius+1) : # these for loops cycle through to make a NE-SW pointing diamond
			if abs(i+j)>radius: # use this condition to get hexagon shape (cutting off the ends of the diamond) 
				continue #skip this cycle of the for loop
			if i == 0 and j == 0 and exclude_center :
				continue
			a.append(Vector2i(center.x+i,center.y+j))
	return a

## Exactly like get_coords_in_hexagon() except returns a list of all hexes in those grid spots.
func get_hexes_in_hexagon(radius: int, center: Vector2i = Vector2i.ZERO, exclude_center: bool = false) -> Array[BaseHex] :
	var a : Array[Vector2i] = get_coords_in_hexagon(radius, center, exclude_center)
	var output : Array[BaseHex] = []
	for c in a :
		if !is_hex_at(c) : continue
		output.append(get_hex(c))
	return output

## Returns the grid coordinates of all nth nearest neighbors to center, ie the ring of hexes n hexes away from center.
func get_nth_nearest_neighbors_coords(n: int, center: Vector2i = Vector2i.ZERO) -> Array[Vector2i]:
	var a : Array[Vector2i] = []
	for i in range(-n, n+1) :
		for j in range(-n, n+1) : # these for loops cycle through to make a NE-SW pointing diamond
			var k : int = HexManager.grid.axial_to_cube_(i,j).z
			if max(abs(i),max(abs(j),abs(k))) != n : # use this condition to get hexagon ring shape
				continue
			a.append(Vector2i(center.x+i,center.y+j))
	return a

## Exactly like get_nth_nearest_neighbor_coords() except returns a list of all hexes in those grid spots.
func get_nth_nearest_neighbors_hexes(n: int, center: Vector2i = Vector2i.ZERO) -> Array[BaseHex]:
	var a : Array[Vector2i] = get_nth_nearest_neighbors_coords(n, center)
	var output : Array[BaseHex] = []
	for c in a :
		if !is_hex_at(c) : continue
		output.append(get_hex(c))
	return output

## Returns the first nearest neighbor coords.
func get_adjacent_coords(center: Vector2i = Vector2i.ZERO) -> Array[Vector2i]:
	return get_nth_nearest_neighbors_coords(1,center)

## Returns the first nearest neighbor hexes.
func get_adjacent_hexes(center: Vector2i = Vector2i.ZERO) -> Array[BaseHex]:
	return get_nth_nearest_neighbors_hexes(1,center)

## Returns what level nearest neighbor these grid_coords are to each other.
func nearest_neighbor_dist(grid_coords_1: Vector2i, grid_coords_2: Vector2i) -> int:
	var rel = grid_coords_1 - grid_coords_2
	var cube = grid.axial_to_cube(rel)
	return max(abs(cube.x),max(abs(cube.y),abs(cube.z)))

## NOTE: HexManager does not provide a function to filter arrays of BaseHex on a condition, instead use Array.filter()

## Returns a list of hexes that are adjacent to center and meet condition.
func get_adjacent_conditional(center: Vector2i, condition: Callable) -> Array[BaseHex]:
	var adj : Array[BaseHex] = get_nth_nearest_neighbors_hexes(1,center)
	var output : Array[BaseHex] = []
	for hex in adj :
		var meets_condition = condition.call(hex)
		if meets_condition :
			output.append(hex)
	return output

## Returns a list of hexes that meet condition and are connected to the hex at center through hexes that meet condition.
func get_contiguous_conditional(center: Vector2i, condition: Callable, check_center:bool=true, search_limit:int=200) -> Array[BaseHex]:
	var check_queue : Array[BaseHex]
	if check_center : check_queue = [ get_hex(center) ]
	else : check_queue = get_adjacent_hexes(center)
	var acknowledged : Array[BaseHex] = check_queue.duplicate()
	var output : Array[BaseHex] = []
	var tries : int = 0
	while tries < search_limit :
		tries += 1
		if check_queue.is_empty() : break
		var next_hex = check_queue.pop_front()
		var meets_condition = await condition.call(next_hex)
		if meets_condition : #if the hex meets the condition
			output.append(next_hex)
			var neighbors = get_adjacent_hexes(next_hex.data.grid_coords)
			for h in neighbors :
				if !acknowledged.has(h) :
					check_queue.append(h)
					acknowledged.append(h)
	return output

#endregion

#region Select

func _unhandled_input(event):
	if not _allow_modify_actions :
		return
	if event is InputEventMouseButton and event.pressed :
		# convert to world coords
		var world_pos = get_global_mouse_position() #only works on Node2D
		var grid_coords : Vector2i = grid.real_to_grid_nearestv(world_pos)
		# call input functions
		if event.button_index == MOUSE_BUTTON_LEFT :
			process_mouse_left_click(grid_coords)

func process_mouse_left_click(coords : Vector2i) :
	if is_hex_at(coords) :
		var hex = get_hex(coords)
		select_hex(hex)
	else :
		deselect_selected_hex()

const reselect_to_deselect = true #internal setting
func select_hex(hex : BaseHex) :
	if reselect_to_deselect : 
		if _selected_hex and hex == _selected_hex :
			deselect_selected_hex()
			return
		deselect_selected_hex()
	else :
		if _selected_hex and hex !=_selected_hex :
			deselect_selected_hex()
	_selected_hex = hex
	hex._is_selected = true
	hex.on_selected()

func try_deselect_hex(hex : BaseHex) :
	if hex.is_selected() :
		deselect_selected_hex()

func deselect_selected_hex() :
	if _selected_hex :
		_selected_hex._is_selected = false
		_selected_hex.on_deselected()
		_selected_hex = null

func is_hex_selected() -> bool :
	return true if _selected_hex else false

func get_selected_hex() -> BaseHex :
	return _selected_hex

#endregion

#region Private

## INTERNAL USE ONLY. You might be looking for create_hex().
## Adds a new hex to hex_list and map and sets its position.
func _register_hex_at(hex: BaseHex, grid_coords: Vector2i):
	hex_list.append(hex)
	_set_hex_position(hex, grid_coords)

## INTERNAL USE ONLY. You might be looking for move_hex(). 
## Directly sets the hexes position. Overrides any existing hex.
func _set_hex_position(hex: BaseHex, grid_coords: Vector2i):
	hex.data.grid_coords = grid_coords
	map.set_entryv(grid_coords,hex)

## INTERNAL USE ONLY. You might be looking for remove_hex().
## Removes a hex from hex_list and map.
func _unregister_hex(hex: BaseHex):
	hex_list.erase(hex)
	map.delete_entryv(hex.data.grid_coords)

#endregion
