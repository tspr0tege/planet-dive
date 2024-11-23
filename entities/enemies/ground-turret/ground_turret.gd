extends CharacterBody2D

@onready var player = get_parent().find_child("Player")
const DEATHNODE = preload("res://entities/enemies/ground-turret/deathnode.tscn")
const RESOURCE = preload("res://entities/drops/resource.tscn")

var player_visible: bool = false


func _on_hp_node_zero_hp() -> void:
	var planet = get_parent()
	var death_explosion = DEATHNODE.instantiate()
	var new_drop = RESOURCE.instantiate()
	death_explosion.position = global_position
	new_drop.position = global_position
	planet.call_deferred("add_child", death_explosion)
	planet.call_deferred("add_child", new_drop)
	queue_free()


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
