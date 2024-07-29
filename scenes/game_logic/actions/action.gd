extends Resource
class_name Action

@export_category("Identifiers")
@export var action_name : String = ""

@export_category("Logic")
@export var action_count : int = 0
@export var targets_friend : bool = false
@export var qte_stats : QTEStats

@export_category("Attack")
@export var magic_use : int = 0
@export var damage : int = 0
@export var hit_rate : float = 0

@export_category("Support")
@export var status_effect : StatusEffect
@export var heal_percent : float = 0

func get_action_stats():
	var stats : Dictionary = {
		"name" = action_name,
		
		"action_count" = action_count,
		"targets_friend" = targets_friend,
		"qte_stats" = qte_stats,
		
		"magic_use" = magic_use,
		"damage" = damage,
		"hit_rate" = hit_rate,
		
		"status_effect" = status_effect,
		"heal_percent" = heal_percent,
	}
	
	return stats
