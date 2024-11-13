extends Node

@export var HP: int = 1

signal zero_hp
signal damage_received
signal healing_received

@onready var ENTITY: Node2D = get_parent()

func change_HP_by(amount) -> void:
	HP += amount
	
	if HP <= 0:
		zero_hp.emit()
		
	elif amount < 0:
		damage_received.emit()
	
	elif amount > 0:
		healing_received.emit()
