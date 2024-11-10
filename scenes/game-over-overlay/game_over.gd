extends Control

signal game_over_menu_button_pressed(button_name)

func _ready() -> void:
	%Restart.grab_focus()


func _on_restart_pressed() -> void:
	game_over_menu_button_pressed.emit("restart")
	print("Let's play again!")
	queue_free()


func _on_quit_pressed() -> void:
	game_over_menu_button_pressed.emit("quit")
	print("I QUIT!")
	queue_free()
