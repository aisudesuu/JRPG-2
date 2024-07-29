extends Control

func spawn_action_menu(battler : Battler):
	var new_menu = VBoxContainer.new()
	new_menu.name = battler.name + "_actions"
	# fight (basic attacks)
	# knack (signature skill)
	# skill (skills)
	# block (block)
	# trinkets (items)

func spawn_moves_menu(battler : Battler):
	var new_menu = VBoxContainer.new()
	new_menu.name = battler.name + "_moves"
	add_child(new_menu)
	for move in battler.stats.actions:
		var new_button = Button.new()
		new_button.name = move.action_name
		new_button.text = move.action_name
		new_button.add_to_group("moves")
		new_button.button_down.connect(_on_button_pressed.bind(new_button))
		new_menu.add_child(new_button)

func _on_button_pressed(button : Button):
	Global.menu_item_pressed.emit(button)
