extends Node

var CURRENT_SCENE: String = "Main Menu"

func _ready() -> void:
	load_current_scene()
	
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
		"Test Planet":
			NEW_SCENE = load("res://scenes/test-planet/planet.tscn").instantiate()
			NEW_SCENE.connect("player_died", _on_player_death)
		_:
			print("Invalid scene name passed to load_scene function in Launcher. Scene name: %s" % CURRENT_SCENE)
	
	add_child(NEW_SCENE)

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
	
	load_current_scene()
	
	get_tree().paused = false
