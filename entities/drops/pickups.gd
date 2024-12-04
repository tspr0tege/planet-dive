extends Area2D

signal points_collected(amount)

const MAX_SPEED: float = 10
var CURRENT_SPEED: float = 0
var fly_to_target: Node2D
var point_value: int = 5

func _ready() -> void:
	connect("points_collected", GameData._handle_points_collected)
	
	point_value = ceil(randf() * 5)
	$AnimatedSprite2D.scale *= (point_value / 10.0) + .5
	

func _process(delta: float) -> void:
	if is_instance_valid(fly_to_target):
		CURRENT_SPEED = lerp(CURRENT_SPEED, MAX_SPEED, delta * .1)
		position += (fly_to_target.global_position - self.global_position) * CURRENT_SPEED
	

func collect() -> void:
	fly_to_target = UniversalReference.PLAYER
	

func collect_resource() -> void:
	points_collected.emit(point_value)
	AudioStreamBus.queue_sfx($AudioStreamPlayer)
	
	queue_free()
	

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		collect_resource()
	
