extends StaticBody2D

@onready var player = get_parent().find_child("Player")

var player_visible: bool = false


func _on_hp_node_zero_hp() -> void:
	print("Oh shit, I'm dead!")


func _process(_delta) -> void:
	if is_instance_valid(player):
		var local_north = Vector2.UP.rotated(self.rotation)
		var rotation_to_player = local_north.dot((player.position - position).normalized())
		player_visible = rotation_to_player > 0
	
	if player_visible:
		$"Shot Timer".paused = false
		$Cannon.look_at(player.global_position)
	elif $"Shot Timer".paused == false:
		$"Shot Timer".paused = true


func _on_shot_timer_timeout() -> void:
	$Cannon.fire_at(player)
