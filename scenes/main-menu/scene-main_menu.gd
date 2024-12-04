extends Control

signal main_menu_button_pressed(button_name)

func _ready() -> void:
	$"VBoxContainer/Start Game".grab_focus()
	$VBoxContainer/Quit.visible = GameData.running_on == "Windows"

func _on_startGame_button_up() -> void:
	main_menu_button_pressed.emit("Start Game")


func _on_high_scores_pressed() -> void:
	main_menu_button_pressed.emit("High Scores")
	

func _on_quit_button_up() -> void:
	main_menu_button_pressed.emit("Quit")
