extends TileMapLayer
class_name Room

var width : int
var height : int
var wall_coord : Vector2i
var floor_coord : Vector2i
var offect : Vector2i

func generate(ptrwall_coord : Vector2i, ptrfloor_coord : Vector2i, course_id : int , global_positon_offect : Vector2i , ptrwidth : int , ptrheight : int):
	offect = global_positon_offect
	width = ptrwidth
	height = ptrheight
	wall_coord = ptrwall_coord
	floor_coord = ptrfloor_coord

func _create_floor(floor_coord: Vector2i, course_id : int , width : int, height: int):
	for w in range(width):
		for h in range(height):
			set_cell(Vector2i(w, h), course_id, floor_coord)

func _create_walls(wall_coord: Vector2i, course_id : int , width : int, height: int):
	for w in range(width):
		set_cell(Vector2i(w + offect.x, 0 + offect.y), course_id, wall_coord)
		set_cell(Vector2i(w + offect.x, height +  + offect.y), course_id, wall_coord)
	for h in range(height):
		set_cell(Vector2i(0 + offect.x, h + offect.y), course_id, wall_coord)
		set_cell(Vector2i(width + offect.x, h + offect.y), course_id, wall_coord)
