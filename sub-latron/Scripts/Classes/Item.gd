extends Node2D
class_name Item

enum STATE {
	is_on_cursor,
	in_inventory
}

enum RARITY {
	common,   # 50%
	uncommon, # 30%
	rare,     # 15%
	epic,     # 4%
	lengedary # 1%
}

enum TYPE {
	ITEM,
	WEAPON,
}
