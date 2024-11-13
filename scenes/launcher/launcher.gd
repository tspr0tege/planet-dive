extends Node

const main_scenes: Dictionary = {
	"MAIN_MENU": {
		"scene": "res://scenes/main-menu/main_menu.tscn",
		"connections": {
			"main_menu_button_pressed": "_on_main_menu_button_pressed"			
		}
	},
	"TEST_PLANET": {
		"scene": "res://scenes/test-planet/planet.tscn",
		"connections": {
			"player_died": "_on_player_death",
			"player_paused": "_on_player_paused"
		},
	},
	"HIGH_SCORES": {
		"scene": "res://scenes/high-scores/high_scores.tscn",
		"connections": {
			
		},
	}
}

const overlay_scenes: Dictionary = {
	"GAME_OVER": {
		"scene": "res://scenes/game-over-overlay/game_over.tscn",
		"connections": {
			"game_over_menu_button_pressed": "_on_game_over_overlay_button_pressed"
		},
	},
	"PAUSE_MENU": {
		"scene": "res://ui/pause_menu.tscn",
		"connections": {
			"close_pause_menu": "_handle_game_unpaused"
		},
	}
}

func _ready() -> void:
	goto_scene("MAIN_MENU")
	

func goto_scene(scene_name: String) -> void:	
	while $"Main Scene Loader".get_child_count() > 0:
		var target = $"Main Scene Loader".get_child(-1)
		$"Main Scene Loader".remove_child(target)
		target.queue_free()	
	
	var NEW_SCENE: Node = load(main_scenes[scene_name].scene).instantiate()
	for key in main_scenes[scene_name].connections:
		NEW_SCENE.connect(key, self[main_scenes[scene_name].connections[key]])
	
	$"Main Scene Loader".call_deferred("add_child", NEW_SCENE)
	
	get_tree().paused = false
	

func load_overlay(scene_name: String) -> void:
	var NEW_OVERLAY: Node = load(overlay_scenes[scene_name].scene).instantiate()
	for key in overlay_scenes[scene_name].connections:
		NEW_OVERLAY.connect(key, self[overlay_scenes[scene_name].connections[key]])
	$Overlay.add_child(NEW_OVERLAY)
	

func _on_main_menu_button_pressed(button_name) -> void:
	match button_name:
		"Start Game":
			print("Start game signal received by Launcher")
			goto_scene("TEST_PLANET")
		"Quit":
			print("Quit signal received by launcher")
			get_tree().quit()
		_:
			print("No match case found in _on_main_menu_button_pressed for button_name: " + str(button_name))


func _on_player_death() -> void:
	if GameData.player_lives > 0:
		goto_scene("TEST_PLANET")
	else:
		load_overlay("GAME_OVER")


func _on_game_over_overlay_button_pressed(button_name) -> void:
	GameData.player_score = 0
	GameData.player_lives = 3
	
	if button_name == "restart":
		print("Restart game signal recieved by Launcher")
		goto_scene("TEST_PLANET")
	elif button_name == "quit": 
		print("Quit game signal received by Launcher")
		goto_scene("MAIN_MENU")
	else:
		print("Unrecognizable value received in button_name of game over button pressed. Received: " + str(button_name))
		

func _on_player_paused() -> void:
	get_tree().paused = true
	print("Pause signal received at the Launcher")
	load_overlay("PAUSE_MENU")


func _handle_game_unpaused(action) -> void:
	get_tree().paused = false
	if action == "Quit":
		goto_scene("MAIN_MENU")
	
