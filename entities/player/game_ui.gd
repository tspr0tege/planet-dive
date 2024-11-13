extends CanvasLayer

const EXTRA_LIFE_ICON = preload("res://ui/1_up_icon.tscn")

func _ready() -> void:
	
	$"UI Container/VBoxContainer/Score".text = "SCORE: " + str(GameData.player_score)	
	for n in range(%Lives.get_child_count(), GameData.player_lives):
		$"UI Container/VBoxContainer/Lives".add_child(EXTRA_LIFE_ICON.instantiate())
	
	GameData.connect("update_score", _handle_score_update)
	

func _handle_score_update() -> void:
	$"UI Container/VBoxContainer/Score".text = "SCORE: " + str(GameData.player_score)
