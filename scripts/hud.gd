class_name HUD
extends Control


@onready var time_label = $TimeLabel

func set_time_label(value: int):
	time_label.text = "TIME: " + str(value)
