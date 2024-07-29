extends Node

# other
signal tree_ready

# menus
signal menu_item_pressed(item)
signal entity_selected(entity)

# player in battle
var in_battle : bool = false
signal entity_fallen(entity)

# player in world
var can_move : bool = false
var global_camera_scene = preload("res://scenes/game_logic/major/world_cam.tscn")
var global_cam : Camera2D

func _ready():
	check_tree_ready()
	load_global_scenes()

func load_global_scenes():
	global_cam = global_camera_scene.instantiate()
	get_tree().root.call_deferred("add_child", global_cam)

func check_tree_ready():
	for child in get_tree().root.get_children():
		await child.ready
		# print(child.name, " is ready!")
	tree_ready.emit()
