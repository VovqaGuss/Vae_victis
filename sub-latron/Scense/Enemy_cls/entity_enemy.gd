extends CharacterBody2D
class_name Enemy

@export var speed : float


func new_target_position(): #CHASE
	return

func new_vector(): #PATROL
	return

func _on_timer_new_target_position_timeout() -> void:
	pass
