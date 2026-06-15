extends TileMapLayer
class_name Room

var center : int
var width : int
var height : int
var wall_coord : Vector2i
var floor_coord : Vector2i

func generate(wall_coord : Vector2i, floor_coord : Vector2i, course_id : int , center : int , width : int , height : int):
	_create_floor(floor_coord, course_id, width, height)
	_create_walls(wall_coord, course_id, width, height)

func _create_floor(floor_coord: Vector2i, course_id : int , width : int, height: int):
	for w in range(width):
		for h in range(height):
			set_cell(Vector2i(w, h), course_id, floor_coord)

func _create_walls(wall_coord: Vector2i, course_id : int , width : int, height: int):
	for w in range(width):
		set_cell(Vector2i(w, ), course_id, wall_coord)
		set_cell(Vector2i(w, height ), course_id, wall_coord)
	for
