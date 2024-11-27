extends Control

signal exit_high_score

const TOP_SCORE_ROW = preload("res://scenes/high-scores/top_score_row.tscn")


func _ready() -> void:
	for n in 10:
		var new_row = TOP_SCORE_ROW.instantiate()
		new_row.get_node("Pos").text = str(10-n) + "."
		if GameData.high_scores.size() > 9-n:
			new_row.get_node("Name").text = str(GameData.high_scores[9-n].name)
			new_row.get_node("Score").text = str(GameData.high_scores[9-n].score)
		$CenterContainer/VBoxContainer/Header.add_sibling(new_row)
	
	$CenterContainer/VBoxContainer/Exit.grab_focus()


func _on_exit_pressed() -> void:
	exit_high_score.emit()
