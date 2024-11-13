extends Area2D

signal points_collected(amount)

const MAX_SPEED: float = 10
var CURRENT_SPEED: float = 0
var fly_to_target: Node2D
var point_value: int = 5

func _ready() -> void:
	connect("points_collected", GameData._handle_points_collected)
	
	var value = ceil(randf() * 5)
	$AnimatedSprite2D.scale *= (value / 10) + .5
	point_value = value
	

func _process(delta: float) -> void:
	if is_instance_valid(fly_to_target):
		CURRENT_SPEED = lerp(CURRENT_SPEED, MAX_SPEED, delta * .1)
		#position = lerp(self.global_position, fly_to_target.global_position, .1)
		position += (fly_to_target.global_position - self.global_position) * CURRENT_SPEED

func collect_to(entity) -> void:
	fly_to_target = entity

func collect_resource() -> void:
	#print(str(point_value) + " resource points collected")
	points_collected.emit(point_value)
	var sound = $AudioStreamPlayer.duplicate()
	get_parent().add_child(sound)
	sound.play()
	queue_free()
	


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		collect_resource()
