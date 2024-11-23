extends CharacterBody2D

const DEATHNODE = preload("res://entities/enemies/space-mine/deathnode.tscn")
const RESOURCE_DROP = preload("res://entities/drops/resource.tscn")


func _process(_delta: float) -> void:
	move_and_slide()


func _on_timer_timeout() -> void:
	queue_free()


func self_destruct() -> void:
	var parent = get_parent()
	var explosion = DEATHNODE.instantiate()
	explosion.position = self.global_position
	parent.call_deferred("add_child", explosion)
	queue_free()


func _on_damage_area_body_entered(body: Node2D) -> void:
	if body != self:
		self_destruct()


func _on_zero_hp() -> void:
	var parent = get_parent()
	var new_resource_drop = RESOURCE_DROP.instantiate()
	new_resource_drop.position = self.global_position
	parent.call_deferred("add_child", new_resource_drop)
	self_destruct()
