extends Control

const TOP_SCORE_ROW = preload("res://scenes/high-scores/top_score_row.tscn")


func _ready() -> void:
	for n in 10:
		var new_row = TOP_SCORE_ROW.instantiate()
		new_row.get_node("Pos").text = str(n + 1) + "."
		if GameData.high_scores.size() > n:
			new_row.get_node("Name").text = str(GameData.high_scores[n].name)
			new_row.get_node("Score").text = str(GameData.high_scores[n].score)
		$CenterContainer/VBoxContainer.add_child(new_row)
