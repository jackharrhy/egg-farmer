@tool
class_name TriggerArea
extends Area3D

enum TriggerStates {
	READY,
	USED
}
var trigger_state: TriggerStates = TriggerStates.READY

@export var target : Node
@export var once : bool

func _func_godot_apply_properties(props: Dictionary) -> void:
	once = props["once"] == "true"
	target = get_node("../entity_" + props["target"])

func trigger():
	if once:
		trigger_state = TriggerStates.USED
	
	target.trigger()

func _on_ent_entered(ent: Node) -> void:
	if trigger_state == TriggerStates.READY:
		if ent.is_in_group("player"):
			trigger()

func _init():
	connect("body_entered", _on_ent_entered)
