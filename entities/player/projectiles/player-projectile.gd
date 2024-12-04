extends Area2D

@export var SPEED: float = 1200

func _ready() -> void:
	AudioStreamBus.queue_sfx($Pew, .05)
	if is_instance_valid(UniversalReference.PLAYER):
		SPEED *= UniversalReference.PLAYER.projectile_direction
	
func _physics_process(delta: float) -> void:
	position.x += SPEED * delta

func _on_lifetime_timeout() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.name =="Player":
		return
	
	if body.has_node("HP Node"):
		body.get_node("HP Node").change_HP_by(-1)
	
	queue_free()
