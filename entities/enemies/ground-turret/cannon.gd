extends Node2D

const TURRET_BULLET = preload("res://entities/enemies/ground-turret/turret_bullet.tscn")

@onready var barrel_exit: Node2D = $"Barrel Exit"

#const barrel_exit = Vector2(-18, 0)

func fire_at(player) -> void:
	var new_bullet = TURRET_BULLET.instantiate()
	var bullet_instantiation_point = barrel_exit.global_position
	new_bullet.position = bullet_instantiation_point
	new_bullet.DIRECTION = bullet_instantiation_point.direction_to(player.global_position).normalized()
	player.get_parent().add_child(new_bullet)
