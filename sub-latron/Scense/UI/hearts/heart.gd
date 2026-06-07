extends Panel

#

@export var Index : int
@onready var sprite_node = $Hearts
var heart_node : HBoxContainer

enum STATE {
	FULL,
	HALF,
	EMPTY
}

func _ready() -> void:
	heart_node = find_parent("HeartBar")
	$Label.text = str(Index)
	
	if heart_node:
		heart_node.change_heart_sprite.connect(_on_change_heart_sprite)
	else:
		print("HeartBar not found!")


func _on_change_heart_sprite(cord : int):
	
	print("Index : ", Index, " Rgstr : ", cord,
	 " == ", Index == cord)
	
	
	if Index == cord:
		match heart_node.hearts_regstr[Index]:
			0: sprite_node.frame = 2; 
			1: sprite_node.frame = 1; 
			2: sprite_node.frame = 0;
	else:
		return

func _on_heart_deleted(amount : int):
	if Index == amount:
		queue_free()
	else:
		return
