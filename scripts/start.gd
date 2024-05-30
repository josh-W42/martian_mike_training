class_name Start

extends StaticBody2D

@onready var spawn_position = $SpawnPostion

func get_spawn_position() -> Vector2:
	return spawn_position.global_position
