class_name Player

extends CharacterBody2D


@export var gravity = 400
@export var speed =  125
@export var jump_force = 200

@onready var animated_sprite = $AnimatedSprite2D

var active = true

func _physics_process(delta):
	if is_on_floor() == false:
		velocity.y += gravity * delta
		if velocity.y > 500:
			velocity.y = 500
		
	var direction = 0
	if active == true:
		if Input.is_action_just_pressed("jump") && is_on_floor():
			jump(jump_force)
			
		# This is a way to get a direction get_axis will be positive if the input is triggered
		# and then negative when the other input is triggered. Also zero if neither is triggered.
		direction = Input.get_axis("left", "right")
	
	if direction != 0: 
		animated_sprite.flip_h = (direction == -1)
		
	velocity.x = direction * speed
	
	move_and_slide()
	
	update_animations(direction)

func update_animations(direction: int):
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("Idle")
		else:
			animated_sprite.play("Run")
	else:
		if velocity.y < 0:
			animated_sprite.play("Jump")
		else:
			animated_sprite.play("Fall")

func _ready():
	pass

func jump(force: int):
	AudioPlayer.play_sfx("jump")
	velocity.y = -force
