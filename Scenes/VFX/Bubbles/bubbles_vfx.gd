extends Node3D
class_name BubbleVFX

@onready var _gpu_particles : GPUParticles3D = %GPUParticles3D

func start():
	_gpu_particles.emitting = true

func stop():
	_gpu_particles.emitting = false
