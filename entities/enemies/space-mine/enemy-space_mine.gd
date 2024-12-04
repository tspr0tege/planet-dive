extends CharacterBody2D

const deathnode = preload("res://entities/enemies/space-mine/deathnode.tscn")
const resource_drop = preload("res://entities/drops/resource.tscn")

@export var SPEED = 200
var direction 


func _ready() -> void:
	if is_instance_valid(UniversalReference.PLAYER):
		direction = global_position.direction_to(UniversalReference.PLAYER.global_position)
	else:
		direction = Vector2(1, 0)
	
	velocity = direction * SPEED
	

func _process(_delta: float) -> void:
	move_and_slide()
	

func _on_timer_timeout() -> void:
	queue_free()
	

func self_destruct() -> void:
	UniversalReference.spawn(deathnode, self.global_position)
	queue_free()
	

func _on_damage_area_body_entered(body: Node2D) -> void:
	if body != self:
		self_destruct()
	

func _on_zero_hp() -> void:
	UniversalReference.spawn(resource_drop, self.global_position)
	self_destruct()
	
