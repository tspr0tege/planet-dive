extends Camera2D


@onready var screen_size = get_viewport_rect().size
@onready var max_camera_offset = (screen_size.x / 2) * .75


func _process(_delta: float) -> void:
	if is_instance_valid(UniversalReference.PLAYER):
		var speed_percent = UniversalReference.PLAYER.speed_percent
		offset.x = lerp(offset.x, floor((max_camera_offset / zoom.x) * speed_percent), GameData.camera_speed / 100)
	
