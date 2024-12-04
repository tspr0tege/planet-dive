extends CanvasLayer

const extra_life_icon = preload("res://scenes/test-planet/HUD/lives_icon.tscn")

func _ready() -> void:
	
	$HUD/VBoxContainer/Score.text = "SCORE: " + str(GameData.player_score)	
	for n in range(%LivesHBox.get_child_count(), GameData.player_lives):
		%LivesHBox.add_child(extra_life_icon.instantiate())
	
	GameData.connect("update_score", _handle_score_update)
	GameData.connect("update_lives", _handle_lives_update)

func _handle_score_update() -> void:
	$HUD/VBoxContainer/Score.text = "SCORE: " + str(GameData.player_score)

func _handle_lives_update() -> void:
	var current_lives = %LivesHBox.get_children()
	var change_in_lives = GameData.player_lives - current_lives.size()
	
	if change_in_lives > 0:
		for n in change_in_lives:
			%LivesHBox.add_child(extra_life_icon.instantiate())
	
	if change_in_lives < 0:
		for n in abs(change_in_lives):
			current_lives[-1].queue_free()
	
