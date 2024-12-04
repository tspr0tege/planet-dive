extends Node2D


func _ready() -> void:
	AudioStreamBus.queue_sfx($Splode, .1)
	$ShipDust.emitting = true
	$Explosion.emitting = true
		

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_node("HP Node"):
		body.get_node("HP Node").change_HP_by(-1)


func _on_explosion_finished() -> void:
	$DmgArea.queue_free()


func _on_ship_dust_finished() -> void:
	queue_free()
