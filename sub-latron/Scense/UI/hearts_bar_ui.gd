extends HBoxContainer
class_name HeartIntarface

enum OPERATION {
	ADD,
	REMOVE
}

signal heart_added(Index : int)
signal heart_deleted(Index : int)

const heart_scene = preload("res://Scense/UI/hearts/heart.tscn")
var hearts_regstr : Array = []

func _ready() -> void:
	update_hearts(OPERATION.ADD)
	update_hearts(OPERATION.ADD)
	update_hearts(OPERATION.ADD)
	on_player_taked_damage(4)
	Eventbus.player_taked_damage.connect(on_player_taked_damage)

func update_hearts(how : OPERATION):
	match how :
		OPERATION.ADD: add_heart()
		OPERATION.REMOVE: heart_delete()


func add_heart():
	heart_added.emit(len(hearts_regstr))
	hearts_regstr.append([len(hearts_regstr), 2])
	
	var heart = heart_scene.instantiate()
	add_child(heart)

func heart_delete():
	heart_deleted.emit(len(hearts_regstr))
	hearts_regstr.pop_back()

func on_player_taked_damage(amount : int):
	var cord = len(hearts_regstr) - 1
	
	
	for hearts in range(len(hearts_regstr)):
		hearts_regstr[cord][1] -= amount
		amount -= 2 ; cord -= 1
	
	print(hearts_regstr)
