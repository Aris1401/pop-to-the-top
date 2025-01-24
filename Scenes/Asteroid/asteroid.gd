extends StaticBody3D
class_name Asteroid

var amount_needed : float = 0.0

# References
var _game : Game

@export var _completion_cooldown : Timer
@export var _animation_player : AnimationPlayer
@export var _bubble_particles : GPUParticles3D

# Signals
signal amount_needed_changed(amount_needed)

func emit_bubbles():
	_bubble_particles.emitting = true

func initialize_amount_needed(time, machines_count):
	if _game:
		amount_needed = get_bubble_needed(time, machines_count)
		amount_needed_changed.emit(amount_needed)
		
		_animation_player.play("popped")

func get_bubble_needed(time, machines_count):
	return 1000 + 500 * machines_count * log(1 + time)

func amount_complete():
	if not _completion_cooldown.timeout.is_connected(_on_completion_cooldown_timeout):
		_completion_cooldown.timeout.connect(_on_completion_cooldown_timeout)
	
	_animation_player.play("bubbled")
	_completion_cooldown.start()

func _on_completion_cooldown_timeout():
	initialize_amount_needed(_game.time, _game.get_machines_count())
