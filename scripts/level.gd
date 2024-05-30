extends Node2D

@export var next_level: PackedScene = null
@export var level_time = 5
@export var is_final_level: bool = false

@onready var start_scene: Start = $Start
@onready var end: End = $End
@onready var dead_zone = $Deadzone
@onready var hud: HUD = $UILayer/HUD
@onready var ui_layer = $UILayer

var player: Player = null

var timer_node = null
var time_left

var win = false

func _ready():
	player = get_tree().get_first_node_in_group("player")
	if player != null:
		reset_player()
		
	var array: Array[Node] = get_tree().get_nodes_in_group("traps")
	
	for node in array:
		#node.connect("player_touched", _on_trap_player_touched())
		node.player_touched.connect(_on_trap_player_touched)
		
	
	end.body_entered.connect(_on_exit_body_entered)
	dead_zone.body_entered.connect(_on_dead_zone_body_entered)
	
	time_left = level_time
	hud.set_time_label(time_left)
	
	timer_node = Timer.new()
	timer_node.name = "Level Timer"
	timer_node.wait_time = 1
	timer_node.timeout.connect(_on_level_timer_timeout)
	add_child(timer_node)
	timer_node.start()
	

func _on_level_timer_timeout():
	if win:
		return
	
	time_left -= 1
	hud.set_time_label(time_left)
	if time_left < 0:
		AudioPlayer.play_sfx("hurt")
		time_left = level_time
		hud.set_time_label(time_left)
		get_tree().reload_current_scene()

func _process(delta):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	elif Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()


func _on_dead_zone_body_entered(body):
	AudioPlayer.play_sfx("hurt")
	reset_player()


func _on_trap_player_touched():
	AudioPlayer.play_sfx("hurt")
	reset_player()
	
func reset_player():
	player.velocity = Vector2.ZERO
	player.global_position = start_scene.get_spawn_position()

func _on_exit_body_entered(body):
	if body is Player:
		win = true
		end.animate()
		player.active = false
		if is_final_level:
			ui_layer.show_win_screen(true)
		elif next_level != null:
			await get_tree().create_timer(1.5).timeout
			get_tree().change_scene_to_packed(next_level)
