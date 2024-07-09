extends RigidBody3D

@onready var egg_mesh = $Egg
@onready var egg_collision = $EggCollision
@onready var breaking_particles = $BreakingParticles
@onready var splat_audio = $SplatAudio

@export var break_velocity = 0.2

var broken = false

func break_egg():
	broken = true
	freeze = true
	egg_mesh.visible = false
	remove_child(egg_collision)
	breaking_particles.emitting = true
	splat_audio.play()
	
	await get_tree().create_timer(2).timeout
	
	queue_free()

func _on_body_entered(body):
	if break_velocity <= linear_velocity.length() or ("linear_velocity" in body and break_velocity <= body.linear_velocity.length()):
		break_egg()
