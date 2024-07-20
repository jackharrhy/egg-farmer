extends CharacterBody3D

@onready var camera_3d = $Camera3D
@onready var character_mover = $CharacterMover

@onready var raycast = $Camera3D/RayCast3D
@onready var hold_position = $Camera3D/HoldPosition

@onready var todo_list = $Camera3D/TodoList

@export var mouse_sensitivity_h = 0.15
@export var mouse_sensitivity_v = 0.15

@export var force_amount = 20
@export var torque_amount = 2

var able_to_hold = true
var holding = false
var held_object : RigidBody3D = null
var held_object_initial_transform : Transform3D

signal started_being_able_to_hold
signal stopped_being_able_to_hold
signal started_holding
signal stopped_holding

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * mouse_sensitivity_h
		camera_3d.rotation_degrees.x -= event.relative.y * mouse_sensitivity_v
		camera_3d.rotation_degrees.x = clamp(camera_3d.rotation_degrees.x, -90, 90)

func _process(_delta):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()

	if Input.is_action_just_pressed("fullscreen"):
		var fs = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
		
		if fs:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

	var input_dir = Input.get_vector("move_left", "move_right", "move_forwards", "move_backwards")
	var move_dir = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	character_mover.set_move_dir(move_dir)

	if not move_dir.is_zero_approx():
		todo_list.bob()

	if Input.is_action_just_pressed("jump"):
		character_mover.jump()

func apply_hold_force():
	var force_dir = hold_position.global_transform.origin - held_object.global_transform.origin
	var distance = force_dir.length()
	force_dir = force_dir.normalized()
	
	var max_distance = 1
	var damping_factor = clamp(distance / max_distance, 0.0, 1.0)
	
	var vec = force_dir * force_amount * damping_factor
	held_object.linear_velocity = vec

func _physics_process(_delta):
	if todo_list.holding:
		if holding:
			drop_held_object()

		if able_to_hold:
			no_longer_can_hold()

		return
	
	if holding:
		apply_hold_force()
		if Input.is_action_just_released("left_click"):
			drop_held_object()
	else:
		var object = raycast.get_collider()

		if object:
			if Input.is_action_just_pressed("left_click"):
				held_object = object
				held_object_initial_transform = Transform3D(object.transform)
				apply_hold_force()
				if "no_longer_holdable" in held_object:
					held_object.no_longer_holdable.connect(drop_held_object)
				holding = true
				started_holding.emit()

			if not able_to_hold:
				able_to_hold = true
				started_being_able_to_hold.emit()
		else:
			if able_to_hold:
				no_longer_can_hold()

func drop_held_object():
	if "no_longer_holdable" in held_object:
		held_object.no_longer_holdable.disconnect(drop_held_object)

	held_object = null
	holding = false
	stopped_holding.emit()

func no_longer_can_hold():
	able_to_hold = false
	stopped_being_able_to_hold.emit()
