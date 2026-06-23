# bsp_node.gd
class_name BSPNode

var rect: Rect2i
var left: BSPNode
var right: BSPNode
var room: Rect2i

const MIN_SIZE = 6

func _init(r: Rect2i) -> void:
	rect = r

func split(depth: int) -> void:
	if depth == 0 or not can_split():
		return
	
	var split_horizontal = randf() > 0.5
	if rect.size.x > rect.size.y * 1.25:
		split_horizontal = false
	elif rect.size.y > rect.size.x * 1.25:
		split_horizontal = true
	
	if split_horizontal:
		var split_y = randi_range(MIN_SIZE, rect.size.y - MIN_SIZE)
		left  = BSPNode.new(Rect2i(rect.position, Vector2i(rect.size.x, split_y)))
		right = BSPNode.new(Rect2i(rect.position + Vector2i(0, split_y),
								   Vector2i(rect.size.x, rect.size.y - split_y)))
	else:
		var split_x = randi_range(MIN_SIZE, rect.size.x - MIN_SIZE)
		left  = BSPNode.new(Rect2i(rect.position, Vector2i(split_x, rect.size.y)))
		right = BSPNode.new(Rect2i(rect.position + Vector2i(split_x, 0),
								   Vector2i(rect.size.x - split_x, rect.size.y)))
	
	left.split(depth - 1)
	right.split(depth - 1)

func can_split() -> bool:
	return rect.size.x >= MIN_SIZE * 2 + 2 or rect.size.y >= MIN_SIZE * 2 + 2

func get_leaves() -> Array[BSPNode]:
	if left == null and right == null:
		return [self]
	var result: Array[BSPNode] = []
	if left:  result.append_array(left.get_leaves())
	if right: result.append_array(right.get_leaves())
	return result
