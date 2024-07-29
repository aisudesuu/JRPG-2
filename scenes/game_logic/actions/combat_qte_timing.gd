extends Control

@onready var hit_circles = $Node2D.get_children()

signal end_mg

var qte_active : bool = false
var hit_circle_idx : int = 0

#region Spawn QTE
func spawn_qte(attacker : Battler, difficulty : int):
	attacker.add_child(self)
	var sprite : Sprite2D = attacker.find_child("Sprite2D")
	global_position = Vector2(
		attacker.global_position.x - (size.x * 0.5 * attacker.scale.x * scale.x),
		attacker.global_position.y - (sprite.texture.get_height() * 1.25 * attacker.scale.y)
	)
	
	for circle in hit_circles:
		circle.visible = false
	
	return await play_qte(difficulty)
#endregion

#region Play QTE
func play_qte(diff : int):
	var result
	
	# replace with animation
	await get_tree().create_timer(0.5).timeout
	
	qte_active = true
	if qte_active:
		play_circles(diff)
		result = await end_mg
	
	# replace with animation
	await get_tree().create_timer(0.5).timeout
	
	queue_free()
	return result

func play_circles(_diff : int):
	for circle in hit_circles:
		await get_tree().create_timer(0.5).timeout
		hit_circles[hit_circle_idx].visible = true
		hit_circle_idx += 1
	# waits one additional beat before default fail
	await get_tree().create_timer(0.5).timeout
	end_mg.emit(-1)

func _input(event):
	if event.is_action_pressed("primary_click"):
		if hit_circle_idx > hit_circles.size() - 2:
			if hit_circle_idx == hit_circles.size():
				end_mg.emit(1)
			else:
				end_mg.emit(0)
			hit_circles[hit_circle_idx - 1].modulate = Color(0, 1, 0)

func end_minigame(result : int):
	qte_active = false
	end_mg.emit(result)

#endregion
