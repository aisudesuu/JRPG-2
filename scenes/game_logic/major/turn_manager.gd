extends Node
class_name TurnManager

# references
@onready var friends : Array # get friends
@onready var foes : Array # get foes
@export var player_action_menus : Control

# track current battle state
enum BattleState {
	NONE,
	START,
	PLAYERTURN,
	ENEMYTURN,
	WIN,
	LOSS
}

func change_state(state : BattleState):
	#print(BattleState.find_key(state))
	match state:
		BattleState.NONE:
			destroy_battle_items()
		BattleState.START:
			battle_setup()
		BattleState.PLAYERTURN:
			player_turn()
		BattleState.ENEMYTURN:
			enemy_turn()
		BattleState.WIN:
			battle_win()
		BattleState.LOSS:
			battle_loss()

func _enter_tree():
	for child in get_children():
		await child.ready
	
	friends = find_child("Friend").get_children()
	foes = find_child("Foe").get_children()
	
	change_state(BattleState.START)

#region Battle Setup
func battle_setup():
	Global.global_cam.setup_camera(null, Vector2(1, 1), Camera2D.ANCHOR_MODE_FIXED_TOP_LEFT, Vector2(0, 0))
	
	# ready entities
	var battle_rect : Vector2 = Global.global_cam.get_window().size
	for i in foes.size():
		foes[i].global_position = Vector2(
			battle_rect.x * 0.8,
			(battle_rect.y / foes.size()) + (i * (battle_rect.y / foes.size()))
		)
		foes[i].entity_selector.set_selector_position()
		foes[i].battle_ready()
		
	for i in friends.size():
		friends[i].global_position = Vector2(
			battle_rect.x * 0.2,
			(battle_rect.y / friends.size()) + (i * (battle_rect.y / friends.size()))
		)
		friends[i].entity_selector.set_selector_position()
		friends[i].battle_ready()
	
	# spawn action menus
	for friend in friends:
		friend.battle_ready()
		player_action_menus.spawn_moves_menu(friend)
	
	for foe in foes:
		foe.battle_ready()
	
	Global.in_battle = true
	change_state(BattleState.PLAYERTURN)
#endregion

#region Player Turn Logic
var player_index : int = 0
var active_player : Battler
var actions_remaining : int = 3

func player_turn():
	$Label.visible = true
	$Label2.visible = true
	$Label2.text = str(actions_remaining)
	active_player = friends[player_index]
	#print(active_player)

	for friend in friends:
		if friend.name != active_player.name:
			player_action_menus.get_child(friend.get_index()).visible = false
		else:
			player_action_menus.get_child(friend.get_index()).visible = true

	var target : Battler
	$Label.text = "Choose an Action!"
	var action_button : Button = await Global.menu_item_pressed
	var action : Action

	# choose action
	while !action_button.is_in_group("moves") or get_action_from_menu(action_button).action_count > actions_remaining:
		action_button = await Global.menu_item_pressed
	action = get_action_from_menu(action_button)
	
	# choose target
	$Label.text = "Choose a Target!"
	target = await Global.entity_selected
	while (target == null) or (target.stats.is_party_member != action.targets_friend):
		target = await Global.entity_selected

	# do damage
	actions_remaining -= action.action_count
	$Label2.text = str(actions_remaining)
	await target.action_component.handle_action(active_player, target, action)
	await update_alive_entities()
	#print(action.action_name, " -> ", target)
	
	# continuing to next turn
	end_player_turn()

func end_player_turn():
	if (actions_remaining > 0):
		player_index = (player_index + 1) % friends.size()
		change_state(BattleState.PLAYERTURN)
	else:
		$Label.visible = false
		$Label2.visible = false
		player_action_menus.get_child(player_index).visible = false
		actions_remaining = 3
		player_index = 0
		change_state(BattleState.ENEMYTURN)

func get_action_from_menu(action_button : Button):
	for action in active_player.stats.actions:
		var action_name = action.action_name
		if action_name == action_button.name:
			return action
#endregion

#region Enemy Turn Logic
var enemy_index : int = 0
var active_enemy : Battler

func enemy_turn():
	active_enemy = foes[enemy_index]
	
	var action : Action = active_enemy.stats.actions.pick_random()
	var target : Battler = friends.pick_random()
	
	var action_component : ActionComponent = target.action_component
	await action_component.handle_action(active_enemy, target, action)
	await update_alive_entities()
	#print(action.action_name, " -> ", target)
	
	action = null
	target = null
	
	end_enemy_turn()

func end_enemy_turn():
	if enemy_index < foes.size() - 1:
		enemy_index += 1
		change_state(BattleState.ENEMYTURN)
	else:
		enemy_index = 0
		change_state(BattleState.PLAYERTURN)

#endregion

func update_alive_entities():
	await get_tree().process_frame
	friends = $Friend.get_children()
	foes = $Foe.get_children()
	check_win_state()

func check_win_state():
	if foes.is_empty():
		change_state(BattleState.WIN)
	elif friends.is_empty():
		change_state(BattleState.LOSS)
	else: return

func destroy_battle_items():
	player_action_menus.queue_free()
	queue_free()

func battle_win():
	print("Battle won!")
	Global.in_battle = false
	change_state(BattleState.NONE)

func battle_loss():
	print("You lost the battle...")
	Global.in_battle = false
	change_state(BattleState.NONE)
