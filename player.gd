extends CharacterBody2D

@export var max_speed: float = 300
@export var acceleration: float = 200
@export var deceleration: float = 500

enum State { IDLE, ACCELERATING, DECELERATING }
var current_state: State = State.IDLE
var current_speed: float = 0

const ACCELERATE_BUTTON = "Button Pad South"
const DECELERATE_BUTTON = "Button Pad East"

func _physics_process(delta: float) -> void:
	update_state()
	
	if position.x > 1200:
		position.x = 0

	match current_state:
		State.IDLE:
			apply_idle(delta)
		State.ACCELERATING:
			apply_acceleration(delta)
		State.DECELERATING:
			apply_deceleration(delta)

	move_and_slide()

func update_state() -> void:
	if Input.is_action_pressed(ACCELERATE_BUTTON):
		current_state = State.ACCELERATING
	elif Input.is_action_pressed(DECELERATE_BUTTON):
		current_state = State.DECELERATING
	else:
		current_state = State.IDLE

func apply_idle(delta: float) -> void:
	if velocity.x > 0:
		velocity.x -= (deceleration / 10) * delta
	if velocity.x < 0:
		velocity.x = 0

func apply_acceleration(delta: float) -> void:
	velocity.x += acceleration * delta
	velocity.x = max(velocity.x, max_speed) 

func apply_deceleration(delta: float) -> void:
	if velocity.x > 0:
		velocity.x -= deceleration * delta
	if velocity.x < 0:
		velocity.x = 0
