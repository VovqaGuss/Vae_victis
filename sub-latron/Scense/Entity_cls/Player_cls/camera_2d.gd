extends Camera2D


func _process(delta: float) -> void:
	offset = Vector2(clamp(get_local_mouse_position().x  * delta * 5, -15, 15),clamp(get_local_mouse_position().y * delta * 5, -15, 15))
