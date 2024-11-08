extends CharacterBody2D

@onready var screen_size = get_viewport_rect().size
@onready var max_camera_offset = (screen_size.x / 2) * .75
@onready var BULLET_SPAWNER: Node2D = $"Bullet Instantiation Point"
@onready var camera: Camera2D = $Camera2D

@export var max_speed: float = 600
@export var acceleration: float = 1000
@export var idle_deceleration: float = 50
@export var vertical_speed: float = 500

const projectile = preload("res://entities/player/projectiles/projectile.tscn")

enum State { IDLE, ACCELERATING, STOPPED }
var current_state: State = State.IDLE
var current_speed: float = 0
var direction: Vector2 = Vector2.ZERO
var projectile_direction: int = 1

func _physics_process(delta: float) -> void:
	update_state()
	
	velocity = Vector2(current_speed, direction.y * vertical_speed)
	var speed_percent = floor((current_speed / max_speed) * 100) / 100
	#var camera_offset = floor(max_camera_offset * speed_percent)
	#$"Debug Label".text = "Camera Offset: " + str(camera_offset)
	#$"Debug Label".text = "projectile direction: " + str(projectile_direction)
	#$"Debug Label".text = "Camera Offset: " + str(camera_offset)
	camera.offset.x = lerp(camera.offset.x, floor(max_camera_offset * speed_percent), .1) #create setting variable
	
	if direction.x < 0 and not $AnimatedSprite2D.flip_h:
		$AnimatedSprite2D.flip_h = true
		$"Bullet Instantiation Point".position.x = -20
		projectile_direction = -1
	if direction.x > 0 and $AnimatedSprite2D.flip_h:
		$AnimatedSprite2D.flip_h = false
		$"Bullet Instantiation Point".position.x = 20
		projectile_direction = 1
		
	if $AnimatedSprite2D.animation != "move-up" and direction.y < 0: #pulling up
		$AnimatedSprite2D.play("move-up")
	elif $AnimatedSprite2D.animation != "move-down" and direction.y > 0: #pulling down
		$AnimatedSprite2D.play("move-down")
	elif direction.y == 0: #level
		$AnimatedSprite2D.play("idle")
	
	if Input.is_action_just_pressed("Button Pad South"):
		var NEW_PROJECTILE = projectile.instantiate()
		NEW_PROJECTILE.position = $"Bullet Instantiation Point".global_position
		NEW_PROJECTILE.SPEED *= projectile_direction
		$"..".add_child(NEW_PROJECTILE)

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
	direction = Vector2( Input.get_axis("ui_left", "ui_right"), Input.get_axis("ui_up", "ui_down"))
	
	#$"Debug Label".text = str(State.keys()[current_state])
	
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
	


func _on_pickup_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("Pickups"):
		area.collect_to($".")
