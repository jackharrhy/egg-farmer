@tool
extends AudioStreamPlayer3D

func _func_godot_apply_properties(props: Dictionary) -> void:
	var sound_file = props["sound_file"]
	assert(sound_file != "", "sound_file must be defined")
	stream = load("res://assets/sounds/" + sound_file + ".ogg")
	if "db" in props:
		volume_db = int(props["db"])

func trigger():
	play()
