extends RigidBody3D

@onready var egg_mesh = $Egg
@onready var egg_collision = $EggCollision
@onready var breaking_particles = $BreakingParticles
@onready var splat_audio = $SplatAudio

@export var egg_splat_scene : PackedScene

@export var break_velocity = 0.2

signal no_longer_holdable

var broken = false

func break_egg():
	no_longer_holdable.emit()
	broken = true
	freeze = true
	egg_mesh.visible = false
	remove_child(egg_collision)
	breaking_particles.emitting = true
	splat_audio.play()
	
	await get_tree().create_timer(2).timeout
	
	queue_free()

func create_splat(pos, rot):
	var splat = egg_splat_scene.instantiate()
	splat.position = pos
	splat.rotation = rot # TODO rot is wrong, idk why
	get_tree().root.add_child(splat)

func _on_body_entered(body):
	if break_velocity <= linear_velocity.length() or ("linear_velocity" in body and break_velocity <= body.linear_velocity.length()):
		# var collision_shape = get_world_3d().direct_space_state
		
		var egg_state = PhysicsServer3D.body_get_direct_state(self)
		# var body_state = PhysicsServer3D.body_get_direct_state(body.get_rid())
		
		var pos = egg_state.get_contact_collider_position(0)
		var rot = egg_state.get_contact_local_normal(0)
		
		create_splat(pos, rot)
		break_egg()
