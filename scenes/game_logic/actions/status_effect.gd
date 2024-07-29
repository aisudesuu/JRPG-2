extends Resource
class_name StatusEffect

@export_enum(
	"POWER",
	"DEFENSE",
	"SPEED"
) var status_type : String = "POWER"
@export var effect_percent : float = 0
@export var is_buff : bool = true

func check_is_buff():
	if is_buff:
		return 1.0
	else: return -1.0

func apply_status(target : Battler):
	match status_type:
		"POWER":
			target.stats.power *= 1.0 + (effect_percent * check_is_buff())
		"DEFENSE":
			target.stats.defense *= 1.0 + (effect_percent * check_is_buff())
		"SPEED":
			target.stats.speed *= 1.0 + (effect_percent * check_is_buff())
	
	target.stats.power = clampf(target.stats.power, target.stats.df_power * 0.5, target.stats.df_power * 2)
	target.stats.defense = clampf(target.stats.defense, target.stats.df_defense * 0.5, target.stats.df_defense * 2)
	target.stats.speed = clampf(target.stats.speed, target.stats.df_speed * 0.5, target.stats.df_speed * 2)
	
	#print("pwr: ", target.stats.power)
	#print("def: ", target.stats.defense)
	#print("spd: ", target.stats.speed)
