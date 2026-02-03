extends TileMapLayer

const main_atlas_id = 0

enum {NONE=-1, LILYPAD=0, FLY=1, FLOWER=2}
var cur_building: int = NONE
var building_dict = {
	NONE : Vector2i(2, 0), # water
	LILYPAD : Vector2i(0,0),
	FLY : Vector2i(1,0),
	FLOWER: Vector2i(3,0),
}
# TODO: find if there's a less scuffed way to do this
var reverse_building_dict = {
	Vector2i(2, 0): NONE, # water
	Vector2i(0,0): LILYPAD,
	Vector2i(1,0): FLY,
	Vector2i(3,0): FLOWER,
}
var building_counter = {
	NONE: 0,
	LILYPAD: 0,
	FLY: 0,
	FLOWER:0
}

# fly stuff
@onready var fly_counter: Label = $"../Control/ResourceUI/VBoxContainer/FlyCounter"
var num_flies: int = 250
var building_cost = {
	NONE : 0,
	LILYPAD: 200,
	FLY: 100,
	FLOWER: 150,
}
var fly_income: int = 0

# frog stuff
@onready var frog_counter: Label = $"../Control/ResourceUI/VBoxContainer/FrogCounter"
var num_frogs: int = 0
var frog_capacity: int = 2

# meters
@onready var happy_bar: TextureProgressBar = $"../Control/ResourceUI/Bars/HappyBar"
var num_happy: int = 0
@onready var energy_bar: TextureProgressBar = $"../Control/ResourceUI/Bars/EnergyBar"
var num_energy: int = 0

func set_building(type):
	cur_building = type

func dist(pos1: Vector2i, pos2: Vector2i):
	var dq = abs(pos1.x-pos2.x)
	var dr = abs(pos1.y-pos2.y)
	var dqplusr = abs(dq+dr)
	return max(dq, dr, dqplusr)

func _input(event):
	if event is InputEventMouseButton:
		var global_clicked = event.position
		var pos_clicked = local_to_map(to_local(global_clicked))
		# if there is a tile where the mouse was clicked
		if get_cell_atlas_coords(pos_clicked) != Vector2i(-1,-1):
			# on left click, if water isn't selected
			if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed() and cur_building != NONE:
				# which type of tile was clicked (INCREDIBLY scuffed)
				var tile_clicked = reverse_building_dict[get_cell_atlas_coords(pos_clicked)]
				# checks the cost
				if num_flies >= building_cost[cur_building]:
					set_cell( pos_clicked, main_atlas_id, building_dict[cur_building] )
					num_flies -= building_cost[cur_building]
					building_counter[cur_building] += 1
					building_counter[tile_clicked] -= 1
				else:
					print("Not enough flies to build " + str(cur_building))
					#TODO: add feedback in-game
		
			elif event.button_index == MOUSE_BUTTON_RIGHT and event.is_pressed():
				var tile_clicked = reverse_building_dict[get_cell_atlas_coords(pos_clicked)]
				set_cell( pos_clicked, main_atlas_id, building_dict[NONE] )
				num_flies += building_cost[tile_clicked]/2
				building_counter[tile_clicked] -= 1
		
		#elif event.button_index == MOUSE_BUTTON_MIDDLE and event.is_pressed():
		
		# update variables
		fly_income = 25 * building_counter[FLY]
		num_energy = 1 * building_counter[LILYPAD]
		num_happy = 1 * building_counter[FLOWER]
		#frog_capacity = 2 + building_counter[FLY]

func _process(_delta):
	fly_counter.text = "🪰: " + str(num_flies)
	frog_counter.text = "🐸: " + str(num_frogs) + "/" + str(frog_capacity)
	happy_bar.value = num_happy
	energy_bar.value = num_energy

func _on_timer_timeout() -> void:
	num_flies += fly_income
