extends HBoxContainer
class_name HeartIntarface

enum OPERATION {
	ADD,
	REMOVE
}

signal change_heart_sprite(cord : int)

const heart_scene = preload("res://Scense/UI/hearts/heart.tscn")
@export var hearts_regstr : Array = []

var clear_len_rsgtr : int = len(hearts_regstr) - 1

@export var count_hearts : int 

func _ready() -> void:
	for i in range(15):
		update_hearts(OPERATION.ADD)
	Eventbus.player_taked_damage.connect(_on_player_taked_damage)

func update_hearts(how : OPERATION):
	if how == OPERATION.ADD:      hearts_regstr.append(2)  
	elif how == OPERATION.REMOVE: heart_delete()
	$Label.text = str(hearts_regstr)

func add_heart():
	var Index : int = len(hearts_regstr)
	hearts_regstr.append(2)
	
	var heart = heart_scene.instantiate()
	heart.Index = Index
	add_child(heart)

func heart_delete():
	hearts_regstr.pop_back()

func _on_player_taked_damage(amount : int):
	
	for i in range(amount):
		hearts_regstr[clear_len_rsgtr] -= 1
		if hearts_regstr[clear_len_rsgtr] == 0:
			clear_len_rsgtr -= 1
			print("Next heart regstr to: ", clear_len_rsgtr)
	$Label.text = str(hearts_regstr)
	
	
	print(hearts_regstr)


func _on_button_pressed() -> void:
	_on_player_taked_damage(int($"../TextEdit".text))
