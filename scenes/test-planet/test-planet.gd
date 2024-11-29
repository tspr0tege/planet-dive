extends Node2D

@export var spawn_point: PathFollow2D
#@export var space_mine: PackedScene
#@export var ground_turret: PackedScene

var enemy_pool: Array = [
	{
		"node": preload("res://entities/enemies/ground-turret/ground_turret.tscn"),
		"current_count": 0,
		"max_count": 5,
		"spawn_behavior": "spawn_turret"
	},
	{
		"node": preload("res://entities/enemies/space-mine/weiner.tscn"),
		"current_count": 0,
		"max_count": 5,
		"spawn_behavior": "spawn_mine"
	},
]

var spawning_turret: bool = false

signal player_died
signal player_paused

func _physics_process(_delta: float) -> void:
	if spawning_turret:
		# generate raycast start point
		spawn_point.progress_ratio = round(randf())
		var grid_position = spawn_point.global_position
		grid_position.x -= (fmod(grid_position.x,  21) + 10.5)
		
		var query = PhysicsRayQueryParameters2D.create(grid_position, grid_position + Vector2(0 , 1600))
		var ray_cast_result = get_world_2d().direct_space_state.intersect_ray(query)
		
		if ray_cast_result.collider == $Map/TileMapLayer or ray_cast_result.collider == $Map/TileMapLayer2:
			var new_enemy_unit = enemy_pool[0].node.instantiate()
			new_enemy_unit.position = ray_cast_result.position
			new_enemy_unit.rotation = Vector2.UP.angle_to(ray_cast_result.normal)
			
			enemy_pool[0].current_count += 1
			new_enemy_unit.connect("tree_exited", _on_enemy_removed.bind(0))
			
			add_child(new_enemy_unit)
			
		spawning_turret = false
	

func _on_MobTimer_timeout():
	var spawnable_enemies = enemy_pool.filter(func (enemy_dict):
		return enemy_dict.current_count < enemy_dict.max_count
	)
	
	if spawnable_enemies.size() > 0:
		var chosen_enemy = spawnable_enemies[randi() % spawnable_enemies.size()]
		call(chosen_enemy.spawn_behavior)
	

func spawn_mine() -> void:
	#Flying Mine creation
	spawn_point.progress_ratio = randf()
	
	var new_enemy_unit = enemy_pool[1].node.instantiate()
	new_enemy_unit.position = spawn_point.global_position
	var direction = new_enemy_unit.global_position.direction_to($Player.global_position)
	new_enemy_unit.velocity = direction * 200
	
	enemy_pool[1].current_count += 1
	new_enemy_unit.connect("tree_exited", _on_enemy_removed.bind(1))
	
	add_child(new_enemy_unit)
	

func spawn_turret() -> void:
	spawning_turret = true
	

func _on_enemy_removed(index) -> void:
	enemy_pool[index].current_count -= 1

func _on_player_player_died() -> void:
	player_died.emit()


func _on_player_paused() -> void:
	player_paused.emit()


func _on_bgm_finished() -> void:
	if $BGM.playing == false:
		$BGM.play()
