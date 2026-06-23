extends Node2D
# dungeon_generator.gd

@export var map_width:  int = 80
@export var map_height: int = 60
@export var bsp_depth:  int = 4
@export var tile_map:   TileMap

const FLOOR = Vector2i(7, 3)  # координата тайла пола в TileSet
const WALL  = Vector2i(7, 2)  # координата тайла стены

var rooms: Array[Rect2i] = []

func _ready() -> void:
	generate()

func generate() -> void:
	rooms.clear()
	tile_map.clear()
	
	# 1. BSP
	var root = BSPNode.new(Rect2i(0, 0, map_width, map_height))
	root.split(bsp_depth)
	
	# 2. Создаём комнаты в листьях
	for leaf in root.get_leaves():
		var room = _create_room(leaf.rect)
		leaf.room = room
		rooms.append(room)
	
	# 3. Соединяем коридорами по MST
	var connections = _minimum_spanning_tree(rooms)
	for pair in connections:
		_carve_corridor(pair[0], pair[1])
	
	# 4. Рисуем стены вокруг пола
	_add_walls()
	
	# 5. Спавним объекты
	_spawn_objects()

# ── Комната ────────────────────────────────────────────────
func _create_room(section: Rect2i) -> Rect2i:
	var padding = 1
	var min_w = 4
	var min_h = 4
	var max_w = section.size.x - padding * 2
	var max_h = section.size.y - padding * 2
	
	var w = randi_range(min_w, max(min_w, max_w))
	var h = randi_range(min_h, max(min_h, max_h))
	var x = section.position.x + padding + randi_range(0, max(0, max_w - w))
	var y = section.position.y + padding + randi_range(0, max(0, max_h - h))
	
	var room = Rect2i(x, y, w, h)
	_carve_rect(room)
	return room

func _carve_rect(r: Rect2i) -> void:
	for cx in range(r.position.x, r.position.x + r.size.x):
		for cy in range(r.position.y, r.position.y + r.size.y):
			tile_map.set_cell(0, Vector2i(cx, cy), 0, FLOOR)

# ── MST (алгоритм Прима) ───────────────────────────────────
func _minimum_spanning_tree(rects: Array[Rect2i]) -> Array:
	if rects.size() < 2:
		return []
	
	var centers = rects.map(func(r): return r.get_center())
	var visited = [0]
	var edges = []
	
	while visited.size() < centers.size():
		var best_dist = INF
		var best_pair = []
		
		for v in visited:
			for u in range(centers.size()):
				if u in visited:
					continue
				var d = centers[v].distance_to(centers[u])
				if d < best_dist:
					best_dist = d
					best_pair = [v, u]
		
		visited.append(best_pair[1])
		edges.append([rects[best_pair[0]], rects[best_pair[1]]])
	
	return edges

# ── L-образный коридор ─────────────────────────────────────
func _carve_corridor(a: Rect2i, b: Rect2i) -> void:
	var start = a.get_center()
	var end   = b.get_center()
	
	# Горизонтальный отрезок
	var x_from = min(start.x, end.x)
	var x_to   = max(start.x, end.x)
	for x in range(x_from, x_to + 1):
		tile_map.set_cell(0, Vector2i(x, start.y),     0, FLOOR)
		tile_map.set_cell(0, Vector2i(x, start.y - 1), 0, FLOOR)  # ширина 2 тайла
	
	# Вертикальный отрезок
	var y_from = min(start.y, end.y)
	var y_to   = max(start.y, end.y)
	for y in range(y_from, y_to + 1):
		tile_map.set_cell(0, Vector2i(end.x, y),     0, FLOOR)
		tile_map.set_cell(0, Vector2i(end.x + 1, y), 0, FLOOR)

# ── Стены ──────────────────────────────────────────────────
func _add_walls() -> void:
	var floor_cells = tile_map.get_used_cells(0)
	var floor_set = {}
	for c in floor_cells:
		floor_set[c] = true
	
	var directions = [
		Vector2i(1,0), Vector2i(-1,0), Vector2i(0,1), Vector2i(0,-1),
		Vector2i(1,1), Vector2i(-1,1), Vector2i(1,-1), Vector2i(-1,-1)
	]
	for cell in floor_cells:
		for d in directions:
			var neighbor = cell + d
			if not floor_set.has(neighbor):
				# Используем слой 1 для стен, чтобы не перекрывать пол
				if tile_map.get_cell_source_id(0, neighbor) == -1:
					tile_map.set_cell(0, neighbor, 0, WALL)

# ── Спавн объектов ─────────────────────────────────────────
func _spawn_objects() -> void:
	if rooms.is_empty():
		return
	
	# Игрок — в первой комнате
	var player_pos = rooms[0].get_center()
	get_node("Player").position = tile_map.map_to_local(player_pos)
	
	# Лестница вниз — в последней комнате
	var exit_pos = rooms[-1].get_center()
	# Spawn exit marker at exit_pos
	
	# Враги и предметы — в остальных комнатах
	for i in range(1, rooms.size() - 1):
		var room = rooms[i]
		_spawn_enemies_in_room(room)

func _spawn_enemies_in_room(room: Rect2i) -> void:
	var count = randi_range(1, 3)
	for _i in range(count):
		var x = randi_range(room.position.x + 1, room.position.x + room.size.x - 2)
		var y = randi_range(room.position.y + 1, room.position.y + room.size.y - 2)
		var world_pos = tile_map.map_to_local(Vector2i(x, y))
		# Instantiate enemy scene at world_pos
