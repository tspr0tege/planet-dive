extends Node2D

@export var overlay_target: CanvasLayer
@export var pause_menu: PackedScene
@export var spawn_point: PathFollow2D

var enemy_pool: Array = [
	{
		"node": preload("res://entities/enemies/ground-turret/ground_turret.tscn"),
		"current_count": 0,
		"max_count": 5,
		"insert": "get_ground_spawn"
	},
	{
		"node": preload("res://entities/enemies/space-mine/space_mine.tscn"),
		"current_count": 0,
		"max_count": 5,
		"insert": "get_roof_spawn"
	},
]

var ground_spawn: Vector2 = Vector2.ZERO

signal scene_control(command: String)


func _ready() -> void:
	UniversalReference.GAME_SPACE = self
	

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("Start Button"):
		pause_game()
	
	# generate raycast start point
	spawn_point.progress_ratio = round(randf())
	var grid_position = spawn_point.global_position
	# round start point to center of nearest grid tile
	grid_position.x -= (fmod(grid_position.x,  21) + 10.5)
	
	var query = PhysicsRayQueryParameters2D.create(grid_position, grid_position + Vector2(0 , 1600))
	var ray_cast_result = get_world_2d().direct_space_state.intersect_ray(query)
	
	if not ray_cast_result :
		ground_spawn = Vector2.ZERO
		return
	
	if ray_cast_result.collider.is_in_group("Ground"):
		ground_spawn = ray_cast_result.position
	else:
		ground_spawn = Vector2.ZERO
	

func _on_MobTimer_timeout():
	var spawnable_enemies = enemy_pool.filter(func (enemy):
		var under_max = enemy.current_count < enemy.max_count
		var valid_spawn = call(enemy.insert).length() > 0
		return under_max and valid_spawn
	)
	
	if spawnable_enemies.size() > 0:
		var spawnable = spawnable_enemies[randi() % spawnable_enemies.size()]
		var index = enemy_pool.find(spawnable)
		var new_enemy = UniversalReference.spawn(spawnable.node, call(spawnable.insert))
		new_enemy.connect("tree_exited", _on_enemy_removed.bind(index))
		spawnable.current_count += 1
	

func get_roof_spawn() -> Vector2:
	spawn_point.progress_ratio = randf()
	return spawn_point.global_position
	

func get_ground_spawn() -> Vector2:
	return ground_spawn
	

func _on_enemy_removed(index) -> void:
	enemy_pool[index].current_count -= 1
	

func _on_player_died() -> void:
	var enemies = get_tree().get_nodes_in_group("Weiners")
	for unit in enemies:
		unit.call_deferred("set_process_mode", ProcessMode.PROCESS_MODE_DISABLED)
		
	GameData.set_lives(-1)
	
	call_deferred("set_process_mode", ProcessMode.PROCESS_MODE_DISABLED)
	
	if GameData.player_lives > 0:
		await get_tree().create_timer(3).timeout
		scene_control.emit("Restart")
	else:
		await get_tree().create_timer(3).timeout
		scene_control.emit("Game Over")
	

func pause_game() -> void:
	get_tree().paused = true
	var NEW_OVERLAY: Node = pause_menu.instantiate()
	NEW_OVERLAY.connect("close_pause_menu", unpause_game)
	overlay_target.add_child(NEW_OVERLAY)
	

func unpause_game(quit_selected: bool) -> void:
	get_tree().paused = false
	if quit_selected:
		scene_control.emit("Quit")
	

func _on_bgm_finished() -> void:
	if $BGM.playing == false:
		$BGM.play()
	
