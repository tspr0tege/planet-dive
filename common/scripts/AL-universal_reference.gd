extends Node

var GAME_SPACE
var PLAYER
var CACHE: Dictionary = {}


func spawn(entity: PackedScene, target_position: Vector2) -> Node:
	
	var new_entity = entity.instantiate()
	new_entity.position = target_position
	
	if is_instance_valid(GAME_SPACE):
		GAME_SPACE.call_deferred("add_child", new_entity)
	else:
		get_tree().root.call_deferred("add_child", new_entity)
	
	return new_entity
	
