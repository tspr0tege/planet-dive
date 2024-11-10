extends TileMapLayer

@onready var area_2d: Area2D = $Area2D

func _ready() -> void:
	var allEntities = area_2d.get_overlapping_bodies()
	print(str(allEntities.size()))

func _on_area_2d_body_entered(body: Node2D) -> void:
	var allEntities = area_2d.get_overlapping_bodies()
	for entity in allEntities:
		if entity.is_in_group("Entities"):
			print(str(entity.name))
	pass # Replace with function body.
