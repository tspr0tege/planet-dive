extends Node2D

@onready var spawn_point: PathFollow2D = $"Player/Spawn Rim/Spawn Point"

@export var mob_scene: PackedScene

signal player_died
signal player_paused

func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()

func _on_MobTimer_timeout():
	spawn_point.progress_ratio = randf()
	
	var new_mob = mob_scene.instantiate()
	new_mob.position = spawn_point.global_position
	var direction = new_mob.global_position.direction_to($Player.global_position)
	new_mob.velocity = direction * 200
	
	add_child(new_mob)


func _on_player_player_died() -> void:
	player_died.emit()


func _on_player_paused() -> void:
	print("Player pause received on a Planetary scale!")
	player_paused.emit()
