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
			"scene_control": "_on_scene_control"
		},
	},
	"HIGH_SCORES": {
		"scene": "res://scenes/high-scores/high_scores.tscn",
		"connections": {
			"exit_high_score": "_ready"
		},
	}
}

const overlay_scenes: Dictionary = {
	"GAME_OVER": {
		"scene": "res://scenes/game-over-overlay/game_over.tscn",
		"connections": {
			"scene_control": "_on_scene_control"
		},
	},
}

func _ready() -> void:
	goto_scene("MAIN_MENU")
	

func goto_scene(scene_name: String) -> void:	
	while $MainSceneLoader.get_child_count() > 0:
		var target = $MainSceneLoader.get_child(-1)
		$MainSceneLoader.remove_child(target)
		target.queue_free()	
	
	var NEW_SCENE: Node = load(main_scenes[scene_name].scene).instantiate()
	for key in main_scenes[scene_name].connections:
		NEW_SCENE.connect(key, self[main_scenes[scene_name].connections[key]])
	
	$MainSceneLoader.call_deferred("add_child", NEW_SCENE)
	
	get_tree().paused = false
	

func load_overlay(scene_name: String) -> void:
	var NEW_OVERLAY: Node = load(overlay_scenes[scene_name].scene).instantiate()
	for key in overlay_scenes[scene_name].connections:
		NEW_OVERLAY.connect(key, self[overlay_scenes[scene_name].connections[key]])
	$Overlay.add_child(NEW_OVERLAY)
	

func _on_main_menu_button_pressed(button_name) -> void:
	match button_name:
		"Start Game":
			goto_scene("TEST_PLANET")
		"High Scores":
			goto_scene("HIGH_SCORES")
		"Quit":
			get_tree().quit()
		_:
			print("No match case found in _on_main_menu_button_pressed for button_name: " + str(button_name))
	

func _on_scene_control(command: String) -> void:
	match command:
		"Restart":
			goto_scene("TEST_PLANET")
		"Game Over":
			load_overlay("GAME_OVER")
		"Quit":
			goto_scene("MAIN_MENU")
		_:
			print("scene_control signal received, without valid command. Command value: " + str(command))
	
