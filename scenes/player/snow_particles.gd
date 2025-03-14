extends Node2D
#
#@onready var snow_particles: GPUParticles2D = $"Snow Particles"
#
## Current gravity direction vector (default: down)
#var gravity_direction = Vector2(0, 1)
#
#func _ready():
	## Initial setup of the particle system
	#setup_particles()
#
#func setup_particles():
	## Create a new ParticleProcessMaterial
	#var particle_material = ParticleProcessMaterial.new()
	#
	## Full screen emission - much wider and taller
	#particle_material.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_BOX
	#particle_material.emission_box_extents = Vector3(1000, 1, 1)  # Much wider emission area
	#
	## Appearance settings - bigger particles
	#particle_material.particle_flag_disable_z = true
	#particle_material.gravity = Vector3(gravity_direction.x, gravity_direction.y, 0) * 98
	#
	## Larger scale range for bigger particles
	#particle_material.scale_min = 1.5
	#particle_material.scale_max = 3.0
	#
	## Motion settings
	#particle_material.initial_velocity_min = 20.0
	#particle_material.initial_velocity_max = 40.0
	#particle_material.angular_velocity_min = -10.0
	#particle_material.angular_velocity_max = 10.0
	#
	## Increase spread for more screen coverage
	#particle_material.spread = 10.0
	#
	## Randomize motion slightly
	#particle_material.turbulence_enabled = true
	#particle_material.turbulence_noise_strength = 0.2
	#particle_material.turbulence_noise_scale = 0.8
	#
	## Apply the material to the particles
	#snow_particles.process_material = particle_material
	#
	## Increase amount for fuller coverage
	#snow_particles.amount = 800
	#
	## Increase lifetime for particles to stay on screen longer
	#snow_particles.lifetime = 10.0
	#
	## Always restart the particles when changing properties
	#snow_particles.restart()
#
## Call this function whenever gravity direction changes
#func change_gravity_direction(new_direction: Vector2):
	## Store the new gravity direction
	#gravity_direction = new_direction.normalized()
	#
	## Wait for 0.5 seconds
	#await get_tree().create_timer(0.5).timeout
	#
	## Update emission shape based on gravity direction
	##var material = snow_particles.process_material
	#
	## Update gravity vector
	#material.gravity = Vector3(gravity_direction.x, gravity_direction.y, 0) * 98
	#
	## Adjust emission box based on gravity direction
	## Make sure it's much larger to cover the entire screen
	#if abs(gravity_direction.y) > abs(gravity_direction.x):
		## Vertical gravity (up/down)
		#material.emission_box_extents = Vector3(1000, 1, 1)  # Wider
		#if gravity_direction.y > 0:
			## Down - emit from above the top of screen
			#snow_particles.position = Vector2(0, -400)
		#else:
			## Up - emit from below the bottom of screen
			#snow_particles.position = Vector2(0, 400)
	#else:
		## Horizontal gravity (left/right)
		#material.emission_box_extents = Vector3(1, 600, 1)  # Taller
		#if gravity_direction.x > 0:
			## Right - emit from left side of screen
			#snow_particles.position = Vector2(-600, 0)
		#else:
			## Left - emit from right side of screen
			#snow_particles.position = Vector2(600, 0)
	#
	## Always restart the particles
	#snow_particles.restart()
#
## Example usage: Connect this to your gravity change signal
## For testing, you can change gravity with keyboard
#func _input(event):
	#if event is InputEventKey and event.pressed:
		#match event.keycode:
			#KEY_DOWN:
				#change_gravity_direction(Vector2(0, 1))  # Down
			#KEY_UP:
				#change_gravity_direction(Vector2(0, -1))  # Up
			#KEY_LEFT:
				#change_gravity_direction(Vector2(-1, 0))  # Left
			#KEY_RIGHT:
				#change_gravity_direction(Vector2(1, 0))  # Right
