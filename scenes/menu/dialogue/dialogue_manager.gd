extends Node

@export var dialogue_container : HBoxContainer
@export var speaker_name : Label
@export var text_box : RichTextLabel

var dialogue : Dictionary
var d_queue : Array[String] = []

func _enter_tree():
	dialogue_container.size.x = (get_viewport().size.x * 0.6)
	dialogue_container.size.y = (get_viewport().size.y * 0.2)

func start_dialogue(d_file : JSON):
	Global.can_move = false
	dialogue = load_dialogue(d_file)
	speaker_name.text = dialogue["name"]
	for i in dialogue["lines"]:
		d_queue.append(dialogue["lines"][i])
	d_queue.append(dialogue["lines"]["1"])
	update_textbox()

func update_textbox():
	text_box.text = d_queue.pop_front()

func load_dialogue(d_file : JSON):
	if d_file != null:
		var parsed = d_file.data
		if parsed.size() <= 0:
			push_error("dialogue file is empty")
			return
		return parsed
	else:
		push_error("dialogue file does not exist")

func _input(event):
	if event.is_action_pressed("primary_click"):
		if d_queue.is_empty():
			queue_free()
			Global.can_move = true
		else:
			update_textbox()
