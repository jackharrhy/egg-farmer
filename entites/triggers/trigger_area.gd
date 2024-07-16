@tool
class_name TriggerArea
extends Area3D

enum TriggerStates {
	READY,
	USED
}
var trigger_state: TriggerStates = TriggerStates.READY
var sound : AudioStreamPlayer3D

enum Types {SOUND}

@export var type : Types
@export var once : bool
@export var sound_file : String

func _func_godot_apply_properties(props: Dictionary) -> void:
	once = props["once"] == "true"

	match props["type"]:
		"sound":
			type = Types.SOUND
			sound_file = props["sound_file"]
			assert(sound_file != "", "sound_file must be defined if type is sound")
			sound = AudioStreamPlayer3D.new()
			sound.name = "TriggerAudio"
			sound.stream = load("res://assets/sounds/" + sound_file + ".ogg")
			add_child(sound)
			sound.owner = get_tree().edited_scene_root
		_:
			push_error("Unknown type {}" % props["type"])

func trigger():
	if once:
		trigger_state = TriggerStates.USED
	
	match type:
		Types.SOUND:
			sound.play()
		_:
			push_error("Unhandled type {}" % type)

func _on_ent_entered(ent: Node) -> void:
	if trigger_state == TriggerStates.READY:
		if ent.is_in_group("player"):
			trigger()

func _init():
	connect("body_entered", _on_ent_entered)

func _ready():
	if not Engine.is_editor_hint():
		sound = $TriggerAudio
