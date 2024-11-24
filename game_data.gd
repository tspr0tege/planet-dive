extends Node

signal update_score

var player_score: int = 0
var player_lives: int = 1
var camera_speed: float = 10
var high_scores: Array[Dictionary]

func _handle_points_collected(points) -> void:
	player_score += points
	update_score.emit()

func _has_new_high_score() -> bool:
	if high_scores.size() < 10 or player_score > high_scores[9].score:
		return true
	else:
		return false

func add_new_high_score(player_name: String) -> void:
	
	for position in 10:
		if position >= high_scores.size() or player_score > high_scores[position].score:
			high_scores.insert(position, {"name": player_name, "score": player_score})
			print("Inserting %s and %s in position %s" % [player_name, player_score, position])
			break
		
