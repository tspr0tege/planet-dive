extends Area2D

@export var SPEED: float = 300
var DIRECTION: Vector2 = Vector2(-1, 0)


func _ready() -> void:
	AudioStreamBus.queue_sfx($Pew, .05)
	if is_instance_valid(UniversalReference.PLAYER):
		DIRECTION = self.global_position.direction_to(UniversalReference.PLAYER.global_position)
	

func _physics_process(delta: float) -> void:
	position += DIRECTION * (SPEED * delta)
	

func _on_lifetime_timeout() -> void:
	queue_free()
	

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Weiners"):
		return
	
	if body.has_node("HP Node"):
		body.get_node("HP Node").change_HP_by(-1)
	
	queue_free()
