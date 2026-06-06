extends Panel

var Index : int
@onready var sprite_node = $Hearts

enum STATE {
	FULL,
	HALF,
	EMPTY
}

func _ready() -> void:
	var heart_node : HBoxContainer = find_parent("HeartBar")
	
	if heart_node:
		heart_node.heart_added.connect(_on_heart_added)
		heart_node.heart_deleted.connect(_on_heart_deleted)
	else:
		print("HeartBer not found!")


func change_heart_sprite(sprite : STATE):
	match sprite:
		STATE.FULL: sprite_node.frame = 0
		STATE.HALF: sprite_node.frame = 1
		STATE.EMPTY: sprite_node.frame = 2

func _on_heart_deleted(amount : int):
	if Index == amount:
		queue_free()
	else:
		return

func _on_heart_added(amount : int):
	pass
