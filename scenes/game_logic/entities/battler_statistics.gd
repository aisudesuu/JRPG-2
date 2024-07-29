extends Resource
class_name BattlerStatistics

@export_category("Default Stats")
@export var max_health : int = 0
@export var df_power : int = clamp(0, 0, 99)
@export var df_defense : int = clamp(0, 0, 99)
@export var df_speed : int = clamp(0, 0, 99)
@export var actions : Array[Action] = []

# trackers
var level : int = 1
var status_effects : Dictionary = {}

# modifiable stats
var health : int = 0
var power : float = 0
var defense : float = 0
var speed : float = 0

@export_category("Technical")
@export var is_party_member : bool = false
var is_alive : bool = true
