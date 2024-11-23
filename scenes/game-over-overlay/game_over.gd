extends Control

signal game_over_menu_button_pressed(button_name)

func _ready() -> void:
	set_process_input(false)
	%"High Score Entry Box".visible = GameData._has_new_high_score() 


func _on_restart_pressed() -> void:
	game_over_menu_button_pressed.emit("restart")
	print("Let's play again!")
	queue_free()


func _on_quit_pressed() -> void:
	game_over_menu_button_pressed.emit("quit")
	print("I QUIT!")
	queue_free()


func _on_name_changed(new_text: String) -> void:
	%"High Score Input/SubmitButton".disabled = new_text == ""


func _on_input_text_submitted(new_text: String) -> void:
	if new_text == "":
		return
	
	GameData.add_new_high_score(new_text)
	%"High Score Entry Box".visible = false
	%Restart.grab_focus()


func _on_submit_button_pressed() -> void:
	_on_input_text_submitted(%"High Score Input/LineEdit".text)


func _on_first_input_delay_timeout() -> void:
	set_process_input(true)
	if GameData._has_new_high_score():
		%"High Score Input/LineEdit".grab_focus()
	else:
		%Restart.grab_focus()
