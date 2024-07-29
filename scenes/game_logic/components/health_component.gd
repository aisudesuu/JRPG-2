extends Node
class_name HealthComponent

@export_category("Node References")
@export var health_display : ProgressBar
@export var health_label : Label

# Statistics
var is_blocking : bool = false

func _enter_tree():
	# health HUD setup
	health_display.min_value = 0
	health_display.max_value = get_parent().get_parent().stats.max_health
	health_display.value = health_display.max_value
	
	if health_label:
		health_label.text = str(get_parent().get_parent().stats.max_health)

func handle_damage(attacker : Battler, target : Battler, action_stats : Dictionary):
	var old_health = target.stats.health
	
	if target.stats.is_alive:
		# what happens when an attack goes through:
		if action_stats["damage"] > 0: # for moves that damage
			if target.stats.defense >= action_stats["damage"]:
				target.stats.health -= 1
			else:
				var attack_damage = (sqrt(attacker.stats.power) * sqrt(action_stats["damage"]) + attacker.stats.level)
				var final_damage = (attack_damage - (target.stats.defense / 3)) * check_blocking()
				# print(attacker.name, " -> ", final_damage)
				target.stats.health -= final_damage
		if action_stats["heal_percent"] > 0.0: # for moves that heal
			var heal_amount : int = target.stats.max_health * action_stats["heal_percent"]
			target.stats.health += heal_amount
			
		if check_alive(target) == false:
			target.queue_free()
			Global.entity_fallen.emit(target)
			
			# limits current_hp between 0 and max hp
			target.stats.health = clamp(target.stats.health, 0, target.stats.max_health)
	else:
		target.queue_free()
		Global.entity_fallen.emit(target)
	
	if old_health != target.stats.health:
		update_health_display(old_health, target.stats.health)

func check_alive(target : Battler):
	if target.stats.health <= 0:
		target.stats.is_alive = false
	return target.stats.is_alive

func check_blocking():
	if is_blocking:
		return .5
	else: return 1

func update_health_display(old_health, new_health):
	var health_diff = old_health - new_health
	var pos_neg : int
	pos_neg = 1 if health_diff > 0 else -1
	
	for i in pos_neg * health_diff:
		health_display.value -= 1 * pos_neg
		var timer = get_tree().create_timer(0.2 / health_diff)
		await timer.timeout
	
	if health_label:
		health_label.text = str(new_health)
