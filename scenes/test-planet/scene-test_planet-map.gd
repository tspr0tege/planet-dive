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
	
func _process(_delta: float) -> void:
	# When Player enters the previous zone
	if player.global_position.x < layer_array[0].global_position.x:
		is_player_past_layer_midpoint = true
		layer_array.reverse()
		orient_midpoint()
	
	# When Player crosses the midpoint
	if (player.global_position.x > current_layer_midpoint) != is_player_past_layer_midpoint:
		is_player_past_layer_midpoint = !is_player_past_layer_midpoint
		
		var move_map_by = (layer_array[0].get_used_rect().size.x * tile_size) * 2
		var direction = 1 if is_player_past_layer_midpoint else -1
		var area_box = layer_array[1].get_node("Area2D")
		var inner_entities = area_box.get_overlapping_bodies()
		inner_entities.append_array(area_box.get_overlapping_areas())
		
		layer_array[1].position.x += move_map_by * direction
		for entity in inner_entities:
			if entity.is_in_group("Entities"):
				entity.position.x += move_map_by * direction
		
	
	# When Player enters the next zone
	if player.global_position.x > layer_array[0].global_position.x + (layer_array[0].get_used_rect().size.x * tile_size):
		is_player_past_layer_midpoint = false	
		layer_array.reverse()
		orient_midpoint()

func orient_midpoint() -> void:
	tile_size = layer_array[0].rendering_quadrant_size
	current_layer_midpoint = ((layer_array[0].get_used_rect().size.x * tile_size) / 2) + layer_array[0].global_position.x
	
