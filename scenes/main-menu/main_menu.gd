extends Control

signal main_menu_button_pressed(button_name)

func _on_startGame_button_up() -> void:	
	print("Start game button up")
	main_menu_button_pressed.emit("Start Game")
	

func _on_quit_button_up() -> void:
	print("Quit button up")
	main_menu_button_pressed.emit("Quit")
