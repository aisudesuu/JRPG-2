extends CanvasLayer
class_name LoadingScreen

signal transition_in_complete

@onready var anim_player : AnimationPlayer = $AnimationPlayer
@onready var timer : Timer = $Timer

var starting_anim_name : String

func start_transition(animation_name : String):
	if !anim_player.has_animation(animation_name):
		push_warning("'%s' animation does not exist" % animation_name)
		animation_name = "fade_to_black"
	starting_anim_name = animation_name
	anim_player.play(animation_name)
	timer.start(0.5)
	await anim_player.animation_finished

func finish_transition():
	if !timer.is_stopped():
		await timer.timeout
	
	var ending_anim_name : String = starting_anim_name.replace("to", "from")
	
	if !anim_player.has_animation(ending_anim_name):
		push_warning("'%s' animation does not exist" % ending_anim_name)
		ending_anim_name = "fade_from_black"
	anim_player.play(ending_anim_name)
	
	await anim_player.animation_finished
	queue_free()
