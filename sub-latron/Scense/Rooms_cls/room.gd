@tool
extends TileMapLayer
class_name Room

@export var height : int = 0:
	set(value):
		height = value
		generate_room()

@export var weight : int = 0:
	set(value):
		weight = value
		generate_room()

var center : Vector2i

func generate_room():
	
	clear()
	
	for y in range(height):
		for x in range(weight):
			set_cell(Vector2i(x, y), 1, Vector2i(1, 3))
