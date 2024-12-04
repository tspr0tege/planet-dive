extends CharacterBody2D

const deathnode = preload("res://entities/enemies/ground-turret/deathnode.tscn")
const bullet = preload("res://entities/enemies/ground-turret/turret_bullet.tscn")
const resource = preload("res://entities/drops/resource.tscn")

var player_visible: bool = false


func _ready() -> void:
	# Orient turret to ground rotation
	var query = PhysicsRayQueryParameters2D.create(position + Vector2(0, -10), position + Vector2(0 , 10))
	query.exclude = [self]
	var ray_cast_result = get_world_2d().direct_space_state.intersect_ray(query)
	if ray_cast_result:
		rotation = Vector2.UP.angle_to(ray_cast_result.normal)
	

func _process(_delta) -> void:
	if is_instance_valid(UniversalReference.PLAYER):
		var player = UniversalReference.PLAYER
		var local_north = Vector2.UP.rotated(self.rotation)
		var rotation_to_player = local_north.dot((player.position - position).normalized())
		player_visible = rotation_to_player > 0
	
	if player_visible:
		$ShotTimer.paused = false
		$Cannon.look_at(UniversalReference.PLAYER.global_position)
	elif $ShotTimer.paused == false:
		$ShotTimer.paused = true
		

func _on_hp_node_zero_hp() -> void:
	UniversalReference.spawn(deathnode, self.global_position)
	UniversalReference.spawn(resource, self.global_position)
	
	queue_free()
	

func _on_shot_timer_timeout() -> void:
	UniversalReference.spawn(bullet, $Cannon/BarrelExit.global_position)
	
