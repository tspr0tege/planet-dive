extends Node2D

func _ready() -> void:
	$Shrapnel.emitting = true
	$Explosion.emitting = true
	AudioStreamBus.queue_sfx($AudioStreamPlayer2D, 0)

func _on_explosion_finished() -> void:
	queue_free()
