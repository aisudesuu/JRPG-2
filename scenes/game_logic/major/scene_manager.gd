extends Node

var loading_screen : LoadingScreen
var _loading_screen_scene = preload("res://scenes/menu/main_menus/loading_screen.tscn")

func load_new_scene(animation : String, to : PackedScene):
	if to == null:
		push_error("ANIM OR SCENE NULL")
	else:
		loading_screen = _loading_screen_scene.instantiate() as LoadingScreen
		get_tree().root.add_child(loading_screen)
		
		await loading_screen.start_transition(animation)
		transfer_content()
		get_tree().call_deferred("change_scene_to_packed", to)
		await loading_screen.finish_transition()
		

func transfer_content():
	# load content here
	pass
