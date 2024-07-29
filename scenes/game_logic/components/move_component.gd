extends Node
class_name MoveComponent

@export var party : Node

const MOVE_SPEED : int = 300

var party_lead : CharacterBody2D
var follow_pos : Array[Vector2] = []

func _ready():
	await Global.tree_ready
	
	party_lead = party.get_child(0)
	Global.global_cam.setup_camera(party_lead, Vector2(1.25, 1.25), Camera2D.ANCHOR_MODE_DRAG_CENTER, Vector2(0, 0))
	Global.can_move = true
	for child in party.get_children():
		if child != party_lead:
			follow_pos.append(party_lead.global_position)
			child.find_child("CollisionShape2D").disabled = true

func _physics_process(_delta):
	if Global.can_move:
		get_input()
		party_lead.move_and_slide()
	follow_lead()

func get_input():
	if !Global.in_battle:
		var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		party_lead.velocity = MOVE_SPEED * input_dir
	else:
		for member in party.get_children():
			member.velocity = Vector2(0, 0)

func follow_lead():
	if !party_lead.velocity.is_zero_approx():
		if follow_pos.back().distance_to(party_lead.global_position) > 128:
			follow_pos.append(party_lead.global_position)
	
	if !follow_pos.is_empty():
		for child in party.get_children():
			if child != party_lead:
				child.velocity = MOVE_SPEED * child.global_position.direction_to(follow_pos[child.get_index() - 1])
				if child.global_position.distance_to(follow_pos[child.get_index() - 1]) > 3: # follow jitter buffer
					child.move_and_slide()
		if follow_pos.size() > party.get_child_count() - 1:
			follow_pos.pop_front()
