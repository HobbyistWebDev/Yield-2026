extends Node

func play(scene: PackedScene, pos: Vector2):
	var new_particle: CPUParticles2D = scene.instantiate()
	add_child(new_particle)
	new_particle.global_position = pos
	new_particle.finished.connect(new_particle.queue_free)
