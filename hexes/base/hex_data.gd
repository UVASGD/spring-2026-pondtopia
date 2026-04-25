extends Resource
class_name HexData

## HexData saves all of the data that needs to be saved for each hex.

## The coordinates of the spot on the map that this hex holds. The hex may not necessarily be at the associated real position.
@export var grid_coords : Vector2i
@export var hex_type : String
@export var _extra_params : Array
