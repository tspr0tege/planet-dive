extends Control

signal scene_control(button_name)

func _ready() -> void:
	set_process_input(false)
	%HighScoreEntryContainer.visible = GameData._has_new_high_score() 
	

func _on_close_game_over(option: String) -> void:
	GameData.reset()
	scene_control.emit(option)
	queue_free()

func _on_name_changed(new_text: String) -> void:
	%HighScoreInput/SubmitButton.disabled = new_text == ""
	

func _on_input_text_submitted(new_text: String) -> void:
	if new_text == "":
		return
	
	GameData.add_new_high_score(new_text)
	%HighScoreInput.visible = false
	%HighScoreEntryContainer/VBoxContainer/Label.text = "New High Score Submitted!"
	%Restart.grab_focus()
	

func _on_submit_button_pressed() -> void:
	_on_input_text_submitted(%HighScoreInput/LineEdit.text)
	

func _on_first_input_delay_timeout() -> void:
	set_process_input(true)
	if GameData._has_new_high_score():
		%HighScoreInput/LineEdit.grab_focus()
	else:
		%Restart.grab_focus()
	
