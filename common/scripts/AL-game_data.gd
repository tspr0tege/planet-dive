extends Node

signal update_score
signal update_lives

@onready var running_on = OS.get_name() #"Web" or "Windows"

const default_score: int = 0
const default_lives: int = 3

var player_score: int = 0
var player_lives: int = 3
var camera_speed: float = 10
var high_scores: Array[Dictionary]

func _ready() -> void:
	if running_on == "Windows":
		
		# Create directory if it doesn't exist
		if DirAccess.open("res://saves") == null:
			var directory = DirAccess.open("res://")
			directory.make_dir("saves")
		
		if FileAccess.file_exists("res://saves/high_scores.dat"):
			var saved_high_scores_file = FileAccess.open("res://saves/high_scores.dat", FileAccess.READ)
			high_scores = saved_high_scores_file.get_var(true)
			saved_high_scores_file.close()
		else:
			print("No save files found")
		
	elif running_on == "Web":
		var _console = JavaScriptBridge.get_interface("console")
		var localStorage = JavaScriptBridge.get_interface("localStorage")
		
		var browser_high_scores = JSON.parse_string(localStorage.getItem("high_scores"))
		
		for entry in browser_high_scores:
			high_scores.push_back(entry)
		

func _handle_points_collected(points) -> void:
	player_score += points
	update_score.emit()
	

func _has_new_high_score() -> bool:
	if high_scores.size() < 10 or player_score > high_scores[9].score:
		return true
	else:
		return false
	

func set_lives(amount: int) -> void:
	player_lives += amount
	update_lives.emit()

func add_new_high_score(player_name: String) -> void:
	for position in 10:
		if position >= high_scores.size() or player_score > high_scores[position].score:
			high_scores.insert(position, {"name": player_name, "score": player_score})
			#print("Inserting %s and %s in position %s" % [player_name, player_score, position])
			break
	
	#save scores
	if running_on == "Windows":
		var high_score_save_file = FileAccess.open("res://saves/high_scores.dat", FileAccess.WRITE)
		print("FileAccess.WRITE status: " + error_string(FileAccess.get_open_error()))
		high_score_save_file.store_var(high_scores.slice(0, 10))
		high_score_save_file.close()
	elif running_on == "Web":
		var localStorage = JavaScriptBridge.get_interface("localStorage")
		localStorage.setItem("high_scores", JSON.stringify(high_scores))
	else:
		print("Unable to save high scores. OS not recognized")
	

func reset() -> void:
	player_score = default_score
	player_lives = default_lives
