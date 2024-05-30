extends Node2D

signal player_touched

func _on_area_2d_body_entered(body):
	if body is Player:
		player_touched.emit()
