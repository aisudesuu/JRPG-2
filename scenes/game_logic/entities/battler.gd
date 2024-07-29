extends Node2D
class_name Battler

# logic
@export var stats : BattlerStatistics
var is_alive : bool = true

@export_category("Battle_Components")
@export var health_component : HealthComponent
@export var action_component : ActionComponent
@export var entity_selector : EntitySelector

func battle_ready():
	# setup modifiables to default values
	stats.health = stats.max_health
	stats.power = stats.df_power
	stats.defense = stats.df_defense
	stats.speed = stats.df_speed
	
	# component setup
	health_component.request_ready()
	
	# label is name
	$Label.text = name
