extends Node

var CURRENT_SCENE: String = "Main Menu"

func _ready() -> void:
	load_current_scene()
	GameData.connect("update_score", _on_update_score)
	
func load_current_scene() -> void:	
	while get_child_count() > 1:
		var target = get_child(-1)
		remove_child(target)
		target.queue_free()
	
	
	var NEW_SCENE: Node
	
	match CURRENT_SCENE:
		"Main Menu":
			NEW_SCENE = load("res://scenes/main-menu/main_menu.tscn").instantiate()
			NEW_SCENE.connect("main_menu_button_pressed", _on_main_menu_button_pressed)
			%"UI-container".visible = false
		"Test Planet":
			NEW_SCENE = load("res://scenes/test-planet/planet.tscn").instantiate()
			NEW_SCENE.connect("player_died", _on_player_death)
			%"UI-container".visible = true
			%"UI-container/VBoxContainer/lives".text = "LIVES: " + str(GameData.player_lives)
			
		_:
			print("Invalid scene name passed to load_scene function in Launcher. Scene name: %s" % CURRENT_SCENE)
	
	call_deferred("add_child", NEW_SCENE)
	
	get_tree().paused = false

func _on_main_menu_button_pressed(button_name) -> void:
	match button_name:
		"Start Game":
			print("Start game signal received by Launcher")
			CURRENT_SCENE = "Test Planet"
			load_current_scene()
		"Quit":
			print("Quit signal received by launcher")
		_:
			print("No match case found in _on_main_menu_button_pressed for button_name: " + str(button_name))

func _on_player_death() -> void:
	print("Player Death signal received by Launcher")
	get_tree().paused = true
	
	if GameData.player_lives > 0:
		GameData.player_lives -= 1
		load_current_scene()
	else:		
		var GAME_OVER_OVERLAY = load("res://scenes/game-over-overlay/game_over.tscn").instantiate()
		GAME_OVER_OVERLAY.connect("game_over_menu_button_pressed", _on_game_over_overlay_button_pressed)
		$Overlay.add_child(GAME_OVER_OVERLAY)

func _on_game_over_overlay_button_pressed(button_name) -> void:
	
	match button_name:
		"restart":
			print("Restart game signal recieved by Launcher")
		"quit":
			print("Quit game signal received by Launcher")
			CURRENT_SCENE = "Main Menu"
		_:
			print("Undefined signal emitted from Game Over overlay, received by Launcher. Received button name: %s from signal" % button_name)
	
	GameData.player_score = 0
	GameData.player_lives = 3
	%"UI-container/VBoxContainer/score".text = "SCORE: 0"
	
	load_current_scene()

func _on_update_score() -> void:
	%"UI-container/VBoxContainer/score".text = "SCORE: " + str(GameData.player_score)
