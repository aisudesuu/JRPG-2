extends Node
class_name InteractComponent

@export var parent : CharacterBody2D
@export var interact_area : Area2D

@onready var battle_manager = preload("res://scenes/game_logic/major/battle_manager.tscn")
@onready var dialogue = preload("res://scenes/menu/dialogue/dialogue.tscn")

func _ready():
	interact_area.body_entered.connect(_on_body_entered)

func _on_body_entered(body : Node2D):
	if body is Wanderer:
		if body.stats.is_party_member != parent.stats.is_party_member:
			if !Global.in_battle:
				SceneManager.load_new_scene("fade_to_black", battle_manager)
				Global.in_battle = true
				
	if body.has_method("get_dialogue"):
		var dialogue_scene = dialogue.instantiate()
		#Global.can_move = false
		dialogue_scene.start_dialogue(body.get_dialogue())
		get_tree().root.add_child(dialogue_scene)
