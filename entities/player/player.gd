extends CharacterBody2D

@onready var screen_size = get_viewport_rect().size
@onready var max_camera_offset = (screen_size.x / 2) * .75
@onready var camera: Camera2D = $Camera2D

@export var max_speed: float = 600
@export var acceleration: float = 1000
@export var idle_deceleration: float = 50
@export var vertical_speed: float = 500

signal player_died
signal player_paused

const projectile = preload("res://entities/player/projectiles/projectile.tscn")

enum State { IDLE, ACCELERATING, STOPPED }
var current_state: State = State.IDLE
var current_speed: float = 0
var direction: Vector2 = Vector2.ZERO
var projectile_direction: int = 1
var shot_available: bool = true

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Start Button"):
		player_paused.emit()
	
	update_state()
	
	velocity = Vector2(current_speed, direction.y * vertical_speed)
	
	var speed_percent = floor((current_speed / max_speed) * 100) / 100
	camera.offset.x = lerp(camera.offset.x, floor((max_camera_offset / camera.zoom.x) * speed_percent), GameData.camera_speed / 100)
	
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
		$"Shot Limit".start()
		
		var NEW_PROJECTILE = projectile.instantiate()
		NEW_PROJECTILE.position = self.position + Vector2(20 * projectile_direction, 0)
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
	get_tree().paused = true
	GameData.player_lives -= 1
	%Lives.get_children()[-1].queue_free()
	player_died.emit()
	print("💀")
	

func _on_pickup_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("Pickups"):
		area.collect_to($".")
	

func _on_shot_limit_timeout() -> void:
	shot_available = true
	
