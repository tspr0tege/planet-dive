extends Node

func queue_sfx(sound: AudioStreamPlayer2D, pitch_variable: float) -> void:
	var new_sound = sound.duplicate()
	new_sound.position = sound.global_position
	new_sound.connect("finished", new_sound.queue_free)
	new_sound.pitch_scale += randf_range(-pitch_variable, pitch_variable)
	add_child(new_sound)
	new_sound.play()
