@tool
extends Node3D

var rng = RandomNumberGenerator.new()

@export var shrub_texture : Texture

func _func_godot_apply_properties(_props: Dictionary) -> void:
	var shrub_index = rng.randi_range(1, 9)
	shrub_texture = load("res://entites/shrubs/P" + str(shrub_index) + ".png")
	setup_texture()

func setup_texture():
	$Sprite3D.texture = shrub_texture

func _ready():
	setup_texture()
