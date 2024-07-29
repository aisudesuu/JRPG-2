extends Node
class_name ActionComponent

@export var health_component : HealthComponent

@onready var qte_1 : PackedScene = preload("res://scenes/game_logic/actions/combat_qte_mash.tscn")
@onready var qte_2 : PackedScene = preload("res://scenes/game_logic/actions/combat_qte_combo.tscn")
@onready var qte_3 : PackedScene = preload("res://scenes/game_logic/actions/combat_qte_timing.tscn")

func handle_action(attacker : Battler, target: Battler, action : Action):
	var action_stats = action.get_action_stats()
	
	var _qte_result
	# mash : buffs & windups
	# combo : debuffs & advanced attacks
	# timing : general attacks
	
	# MUST GO FIRST // handles playing minigames
	if action_stats["qte_stats"] != null and attacker.stats.is_party_member:
		match action_stats["qte_stats"].quick_time_event:
			0: # mash
				var qte_1_scene = qte_1.instantiate()
				_qte_result = action_stats["qte_stats"].get_result(await qte_1_scene.spawn_qte(attacker, 1))
			1: # combo
				var qte_2_scene = qte_2.instantiate()
				_qte_result = action_stats["qte_stats"].get_result(await qte_2_scene.spawn_qte(attacker, action_stats["qte_stats"].sequence))
			2: # timing
				var qte_3_scene = qte_3.instantiate()
				_qte_result = action_stats["qte_stats"].get_result(await qte_3_scene.spawn_qte(attacker, 1))
	
	# handle damage and healing
	if action_stats["damage"] > 0 or action_stats["heal_percent"] > 0.0:
		if randf() <= action_stats["hit_rate"]:
			health_component.handle_damage(attacker, target, action_stats)
	
	# handle status buffs and debuffs
	if action_stats["status_effect"] != null:
		if target.stats.status_effects.has(action_stats["status_effect"]):
			target.stats.status_effects[action_stats["status_effect"]] += 1
		else: target.stats.status_effects[action_stats["status_effect"]] = 1
		
		action_stats["status_effect"].apply_status(target)
