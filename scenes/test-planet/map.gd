extends Node2D

@onready var player: CharacterBody2D = $"../Player"
@onready var layer_1 = $TileMapLayer
@onready var layer_2 = $TileMapLayer2
var layer_array
var current_layer_midpoint
var tile_size
var is_player_past_layer_midpoint: bool = false

func _ready() -> void:
	layer_array = [layer_1, layer_2]
	orient_midpoint()
	
func _process(delta: float) -> void:
	#$"../Player/Debug Label2".text = str("Past midpoint: " + str(player.position.x > current_layer_midpoint))
	if player.global_position.x < layer_array[0].global_position.x:
		#print("Player has entered the previous Zone")
		is_player_past_layer_midpoint = !is_player_past_layer_midpoint
		layer_array.reverse()
		orient_midpoint()
	
	if (player.global_position.x > current_layer_midpoint) != is_player_past_layer_midpoint:
		is_player_past_layer_midpoint = !is_player_past_layer_midpoint
		#print("Player has passed the midpoint")
		var move_map_by = (layer_array[0].get_used_rect().size.x * tile_size) * 2
		if is_player_past_layer_midpoint:
			layer_array[1].position.x += move_map_by
			#print("Alternate map layer moved by +" + str(move_map_by))
		else:
			layer_array[1].position.x -= move_map_by
			#print("Alternate map layer moved by -" + str(move_map_by))
	
	if player.global_position.x > layer_array[0].global_position.x + (layer_array[0].get_used_rect().size.x * tile_size):
		#print("Player has entered the next Zone")	
		is_player_past_layer_midpoint = !is_player_past_layer_midpoint	
		layer_array.reverse()
		orient_midpoint()

func orient_midpoint() -> void:
	tile_size = layer_array[0].rendering_quadrant_size
	current_layer_midpoint = ((layer_array[0].get_used_rect().size.x * tile_size) / 2) + layer_array[0].global_position.x
	#print("Layer midpoint: " + str(current_layer_midpoint))
	#print("Tile size: " + str(tile_size))
	#print("Layer width: " + str(layer_array[0].get_used_rect().size.x * tile_size))
