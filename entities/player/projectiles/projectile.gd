extends Area2D

@export var SPEED: float = 1000
#@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _physics_process(delta: float) -> void:
	position.x += SPEED * delta

func _on_lifetime_timeout() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.name =="Player":
		return
	
	if body.is_in_group("Weiners"):
		if body.has_method("destroy"):
			body.destroy()
		else:
			print(str(body.name) + " has no destroy function")
			body.queue_free()
	
	queue_free()
