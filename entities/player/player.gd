extends CharacterBody2D

@onready var screen_size = get_viewport_rect().size

@export var max_speed: float = 600
@export var acceleration: float = 1000
@export var idle_deceleration: float = 50
@export var vertical_speed: float = 500

signal player_died

const projectile = preload("res://entities/player/projectiles/projectile.tscn")
const deathnode = preload("res://entities/player/deathnode.tscn")

enum State { IDLE, ACCELERATING, STOPPED }
var current_state: State = State.IDLE
var current_speed: float = 0
var direction: Vector2 = Vector2.ZERO
var projectile_direction: int = 1
var shot_available: bool = true
var speed_percent


func _ready() -> void:
	UniversalReference.PLAYER = self
	

func _physics_process(delta: float) -> void:
	
	update_state()
	
	velocity = Vector2(current_speed, direction.y * vertical_speed)
	
	speed_percent = floor((current_speed / max_speed) * 100) / 100
	
	if direction.x < 0 and not $AnimatedSprite2D.flip_h:
		$AnimatedSprite2D.flip_h = true
		projectile_direction = -1
	if direction.x > 0 and $AnimatedSprite2D.flip_h:
		$AnimatedSprite2D.flip_h = false
		projectile_direction = 1
		
	if $AnimatedSprite2D.animation != "move-up" and direction.y < 0: #pulling up
		$AnimatedSprite2D.play("move-up")
	elif $AnimatedSprite2D.animation != "move-down" and direction.y > 0: #pulling down
		$AnimatedSprite2D.play("move-down")
	elif direction.y == 0: #level
		$AnimatedSprite2D.play("idle")
	
	if shot_available and Input.is_action_pressed("Button Pad South"):
		shot_available = false
		$ShotLimit.start()
		
		var projectile_spawn = self.position + Vector2(20 * projectile_direction, 0)
		UniversalReference.spawn(projectile, projectile_spawn)

	match current_state:
		State.IDLE:
			apply_idle(delta)
		State.ACCELERATING:
			apply_acceleration(delta)

	#position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 10, screen_size.y - 10)
	
	move_and_slide()


func update_state() -> void:
	# Check for directional input
	direction.x = Input.get_axis("ui_left", "ui_right")
	direction.y = Input.get_axis("ui_up", "ui_down")
	
	if direction.x != 0:
		current_state = State.ACCELERATING
	elif current_speed != 0:
		current_state = State.IDLE
	else:
		current_state = State.STOPPED
	

func apply_idle(delta: float) -> void:
	if (absf(current_speed) - idle_deceleration * delta) < 0:
		current_speed = 0	
	elif current_speed > 0:
		current_speed -= idle_deceleration * delta
	elif current_speed < 0:
		current_speed += idle_deceleration * delta
	

func apply_acceleration(delta: float) -> void:
	current_speed += direction.x * acceleration * delta
	current_speed = clamp(current_speed, -max_speed, max_speed)
	

func _handle_healing():
	print("Oo, tasty!")
	

func _handle_damage():
	print("Ouch!")
	

func _handle_death():
	var death_explosion = UniversalReference.spawn(deathnode, self.global_position)
	var process_material = death_explosion.get_node("Shrapnel").process_material	
	process_material.spread = 180 - (135 * (velocity.length() / 500))
	process_material.direction = Vector3(velocity.x, velocity.y, 0)
	process_material.initial_velocity = Vector2((velocity.length() / 3) - 50, velocity.length() / 3)
	
	$AnimatedSprite2D.visible = false
	player_died.emit()
	#print("💀")	
	process_mode = ProcessMode.PROCESS_MODE_DISABLED
	

func _on_pickup_area_area_entered(item: Area2D) -> void:
	if item.is_in_group("Pickups"):
		if item.has_method("collect"):
			item.collect()
		else:
			print("Pickup found without collect() method.")
	

func _on_shot_limit_timeout() -> void:
	shot_available = true
	
