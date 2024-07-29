extends Camera2D

var cam_target : Node2D

func _physics_process(delta):
	if cam_target != null:
		global_position = cam_target.global_position
	else: cam_target = self

func setup_camera(target : Node2D, c_zoom : Vector2, c_anchor_mode : AnchorMode, c_offset : Vector2):
	cam_target = target
	zoom = c_zoom
	anchor_mode = c_anchor_mode
	offset = c_offset
