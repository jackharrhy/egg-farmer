@tool
class_name TriggerEggStorage
extends Area3D

func _func_godot_apply_properties(_props: Dictionary) -> void:
	pass

func _on_timer_timeout() -> void:
	var eggs = []
	for body in get_overlapping_bodies():
		if body.is_in_group("egg"):
			eggs.append(body)
	
	print(eggs.size())

func _init():
	if not Engine.is_editor_hint():
		var timer := Timer.new()
		add_child(timer)
		timer.wait_time = 1.0
		timer.autostart = true
		timer.connect("timeout", _on_timer_timeout)
