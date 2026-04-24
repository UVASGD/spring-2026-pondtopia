extends Resource
class_name HexData

## HexData saves all of the data that needs to be saved for each hex.

## The coordinates of the spot on the map that this hex holds. The hex may not necessarily be at the associated real position.
var grid_coords : Vector2i
var hex_scene_type : PackedScene
