extends Control

@onready var up = $Arrows/UP
@onready var left = $Arrows/LEFT
@onready var down = $Arrows/DOWN
@onready var right = $Arrows/RIGHT

signal p_input(event)
signal end_mg

var qte_active : bool = false

var sequence : Array = []
var seq_index : int = 0

var result : int

#region Spawn QTE
func spawn_qte(attacker : Battler, input_sequence : Array[InputEventKey]):
	attacker.add_child(self)
	var sprite : Sprite2D = attacker.find_child("Sprite2D")
	global_position = Vector2(
		attacker.global_position.x - (sprite.texture.get_size().x * 0.5 * attacker.scale.x),
		attacker.global_position.y + (sprite.texture.get_size().y * 0.5 * attacker.scale.y)
	)
	
	# input sequence display
	for input in input_sequence:
		sequence.append(input.keycode)
		if input.keycode == 4194320:
			$Sequence.add_child(up.duplicate())
		elif input.keycode == 4194322:
			$Sequence.add_child(down.duplicate())
		elif input.keycode == 4194319:
			$Sequence.add_child(left.duplicate())
		elif input.keycode == 4194321:
			$Sequence.add_child(right.duplicate())
	
	return await play_qte()
#endregion

#region Play QTE
func play_qte():
	# replace with animation
	await get_tree().create_timer(0.5).timeout
	
	qte_active = true
	if qte_active:
		_start_timeout(8)
		while qte_active:
			var player_input = await p_input
			if player_input == sequence[seq_index]:
				$Sequence.get_child(seq_index).add_theme_color_override("font_color", "green")
				seq_index += 1
				if seq_index == sequence.size():
					end_minigame(1)
	
	# replace with animation
	await get_tree().create_timer(0.5).timeout
	
	queue_free()
	return result

func _input(event):
	if qte_active:
		if event.is_action_pressed("ui_up") or event.is_action_pressed("ui_down") or event.is_action_pressed("ui_left") or event.is_action_pressed("ui_right"):
			p_input.emit(event.keycode)

func _start_timeout(time : int):
	await get_tree().create_timer(time).timeout
	end_minigame(0)

func end_minigame(r : int):
	qte_active = false
	if r == 0:
		p_input.emit(4194320)
	result = r
#endregion
