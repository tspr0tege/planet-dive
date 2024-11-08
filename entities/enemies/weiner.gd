extends CharacterBody2D

func _process(_delta: float) -> void:
	move_and_slide()

func _on_timer_timeout() -> void:
	queue_free()
	
func destroy() -> void:
	var parent = get_parent()
	var sfx = $Splode.duplicate()
	var fireball = $GPUParticles2D2.duplicate()
	var ship_dust = $GPUParticles2D.duplicate()
	var resource_drop = load("res://entities/drops/resource.tscn").instantiate()
	resource_drop.position = self.global_position
	parent.call_deferred("add_child", resource_drop)
	sfx.position = self.global_position
	fireball.position = self.global_position
	ship_dust.position = self.global_position
	parent.add_child(sfx)
	parent.add_child(fireball)
	parent.add_child(ship_dust)
	sfx.play()
	fireball.emitting = true
	ship_dust.emitting = true
	queue_free()
