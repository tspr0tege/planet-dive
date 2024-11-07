extends Node

var LOADED_SCENE: Node

func _ready() -> void:
	var MAIN_MENU = load("res://main_menu.tscn").instantiate()
	MAIN_MENU.connect("main_menu_button_pressed", _on_main_menu_button_pressed)
	LOADED_SCENE = MAIN_MENU
	add_child(MAIN_MENU)

func _on_main_menu_button_pressed(button_name) -> void:
	match button_name:
		"Start Game":
			print("Start game signal received by Launcher")
			var TEST_PLANET = load("res://planet.tscn").instantiate()
			remove_child(LOADED_SCENE)
			add_child(TEST_PLANET)
		"Quit":
			print("Quit signal received by launcher")
		_:
			print("No match case found in _on_main_menu_button_pressed for button_name: " + str(button_name))
