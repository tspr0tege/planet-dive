extends Node

@export var HP: int = 1

@onready var ENTITY: Node2D = get_parent()

func change_HP_by(amount) -> void:
	HP += amount
	
	if HP <= 0:
		if ENTITY.has_method("_handle_death"):
			ENTITY._handle_death()
		else:
			print(str(ENTITY.name) + "has no handle_death function.")
		return
		
	if amount < 0:
		if ENTITY.has_method("_handle_damage"):
			ENTITY._handle_damage()
		else:
			print(str(ENTITY.name) + "has no handle_damage function.")
	
	if amount > 0:
		if ENTITY.has_method("_handle_healing"):
			ENTITY._handle_healing()
		else:
			print(str(ENTITY.name) + "has no handle_healing function.")
