extends Node2D

@export var spawn_point: PathFollow2D
@export var space_mine: PackedScene
@export var ground_turret: PackedScene

var spawn_turret: bool = false

signal player_died
signal player_paused

func _physics_process(delta: float) -> void:
	if spawn_turret:
		var grid_position = spawn_point.global_position
		grid_position.x -= (fmod(grid_position.x,  21) + 10.5)
		var query = PhysicsRayQueryParameters2D.create(grid_position, grid_position + Vector2(0 , 1600))
		var ray_cast_result = get_world_2d().direct_space_state.intersect_ray(query)
		if ray_cast_result.collider == $Map/TileMapLayer or ray_cast_result.collider == $Map/TileMapLayer2:
			var new_turret = ground_turret.instantiate()
			new_turret.position = ray_cast_result.position
			new_turret.rotation = Vector2.UP.angle_to(ray_cast_result.normal)
			add_child(new_turret)
		else:
			print("TileMapLayer not found by ray cast collider.")
		spawn_turret = false

func _on_MobTimer_timeout():
	if get_tree().get_nodes_in_group("Weiners").size() < 5:
		spawn_point.progress_ratio = round(randf())
		spawn_turret = true
	
	
	#Flying Mine creation
	#spawn_point.progress_ratio = randf()
	#
	#var new_mob = mob_scene.instantiate()
	#new_mob.position = spawn_point.global_position
	#var direction = new_mob.global_position.direction_to($Player.global_position)
	#new_mob.velocity = direction * 200
	#
	#add_child(new_mob)


func _on_player_player_died() -> void:
	player_died.emit()


func _on_player_paused() -> void:
	player_paused.emit()
