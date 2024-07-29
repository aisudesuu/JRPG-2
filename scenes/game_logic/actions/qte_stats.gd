extends Resource
class_name QTEStats

@export_enum("MASH", "COMBO", "TIMING") var quick_time_event = 0
@export var result_bad : float = 0.75
@export var result_good : float = 1.00
@export var result_great : float = 1.50

@export_category("Combo")
@export var sequence : Array[InputEventKey] = []

func get_result(result : int):
	if result == -1:
		return result_bad
	if result == 0:
		return result_good
	if result == 1:
		return result_great
