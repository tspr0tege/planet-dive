extends Node

signal update_score

var player_score: int = 0
var player_lives: int = 3

func _handle_points_collected(points) -> void:
	player_score += points
	update_score.emit()
