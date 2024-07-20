extends Node3D

@onready var audio_stream_player = $AudioStreamPlayer
@onready var animation_player = $AnimationPlayer
@onready var area_3d = $Area3D

var holding = false

func _ready():
	visible = false

func bob():
	if holding && not animation_player.is_playing():
		animation_player.play("bob")

func show_todo():
	if busy() and not is_colliding():
		return

	holding = true
	animation_player.play("show")
	await get_tree().create_timer(0.025).timeout
	visible = true

func is_colliding():
	return not area_3d.get_overlapping_bodies().is_empty()

func busy():
	var not_playing_bob = animation_player.current_animation != "bob"
	var playing = animation_player.is_playing()
	
	return playing and not_playing_bob

func hide_todo():
	if busy():
		return

	holding = false
	animation_player.play("hide")
	audio_stream_player.play()

func _process(_delta):
	if Input.is_action_just_pressed("toggle_todo"):		
		if holding:
			hide_todo()
		else:
			show_todo()

func _on_area_3d_body_entered(_body):
	if holding:
		hide_todo()
