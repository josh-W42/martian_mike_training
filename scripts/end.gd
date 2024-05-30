class_name End

extends Area2D


@onready var animate_sprite = $AnimatedSprite2D

func animate():
	animate_sprite.play("End")
