extends ProgressBar

signal p_input
signal end_mg

var qte_active : bool = false

#region Spawn QTE
func spawn_qte(attacker : Battler, difficulty : int):
	attacker.add_child(self)
	var sprite : Sprite2D = attacker.find_child("Sprite2D")
	global_position = Vector2(
		attacker.global_position.x + (sprite.texture.get_size().x * 0.55 * attacker.scale.x),
		attacker.global_position.y - (sprite.texture.get_size().y * 0.5 * attacker.scale.y)
	)
	size = Vector2(
		sprite.texture.get_width() * 0.2,
		sprite.texture.get_height()
	)
	
	fill_mode = FILL_BOTTOM_TO_TOP
	show_percentage = false
	value = 30
	
	return await play_qte(difficulty)
#endregion

#region Play QTE
func play_qte(difficulty : int):
	# replace with animation
	await get_tree().create_timer(0.5).timeout
	
	qte_active = true
	if qte_active:
		_start_timeout(5)
		value_reduction(difficulty)
		while qte_active == true:
			await p_input
			value += 10
	var result = await end_mg
	
	# replace with animation
	await get_tree().create_timer(0.5).timeout
	
	queue_free()
	return result

func _physics_process(_delta):
	if Input.is_action_just_pressed("primary_click") or Input.is_action_just_pressed("secondary_click"):
		p_input.emit()
	
	if qte_active == true:
		if value == max_value:
			end_minigame(1)
		if value == min_value:
			end_minigame(-1)

func value_reduction(difficulty : int):
	while qte_active == true:
		value -= 2
		await get_tree().create_timer(0.1 / difficulty).timeout

func _start_timeout(time : int):
	await get_tree().create_timer(time).timeout
	end_minigame(0)

func end_minigame(result : int):
	qte_active = false
	p_input.emit()
	end_mg.emit(result)
#endregion
