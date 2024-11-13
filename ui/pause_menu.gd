extends Control

@export var camera_speed_slider: HSlider
@export var camera_speed_display: Label

var input_ready = false

signal close_pause_menu(action)


func _ready() -> void:	
	camera_speed_slider.value = GameData.camera_speed
	camera_speed_display.text = str(GameData.camera_speed)
	

func _process(_delta: float) -> void:
	if input_ready and Input.is_action_just_pressed("Start Button"):
		_on_resume_pressed()
	

func _on_camera_speed_value_changed(value: float) -> void:
	GameData.camera_speed = value
	camera_speed_display.text = str(value)


func _on_resume_pressed() -> void:
	close_pause_menu.emit("Resume")
	queue_free()


func _on_quit_pressed() -> void:
	close_pause_menu.emit("Quit")
	queue_free()


func _on_first_input_delay_timeout() -> void:
	input_ready = true
	%"Resume Button".grab_focus()
