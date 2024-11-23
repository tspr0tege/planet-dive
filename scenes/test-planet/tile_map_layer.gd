extends TileMapLayer

var inner_entities: Array = []


func _add_entity(object) -> void:
	print(str(object.name) + " detected")
	if object.is_in_group("Entities"):
		inner_entities.push_back(object)


func _remove_entity(object) -> void:
	if inner_entities.has(object):
		var index = inner_entities.find(object)
		inner_entities.pop_at(index)
