extends Button
class_name EntitySelector

@export var parent : Node2D
@export var parent_sprite : Sprite2D

func set_selector_position():
	size = parent_sprite.texture.get_size()
	scale = parent_sprite.scale
	global_position = parent.global_position - (parent_sprite.texture.get_size() * 0.5 * parent_sprite.scale)

func _on_button_down():
	Global.entity_selected.emit(parent)
