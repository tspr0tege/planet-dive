extends Area2D

var fly_to_target: Node2D
var point_value: int = 5

func _ready() -> void:
	var scalar = randf()
	$AnimatedSprite2D.scale *= scalar
	point_value = ceil(point_value * scalar)
	

func _process(_delta: float) -> void:
	if is_instance_valid(fly_to_target):
		position = lerp(self.global_position, fly_to_target.global_position, .1)

func collect_to(entity) -> void:
	fly_to_target = entity

func collect_resource() -> void:
	print(str(point_value) + " resource points collected")
	var sound = $AudioStreamPlayer.duplicate()
	get_parent().add_child(sound)
	sound.play()
	queue_free()
	


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		collect_resource()
