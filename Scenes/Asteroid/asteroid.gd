extends StaticBody3D
class_name Asteroid

var amount_needed : float = 0.0

# References
var _game : Game

@export var _completion_cooldown : Timer
@export var _animation_player : AnimationPlayer

# Signals
signal amount_needed_changed(amount_needed)

func initialize_amount_needed(time):
	if _game:
		amount_needed = get_bubble_needed(time)
		amount_needed_changed.emit(amount_needed)
		
		_animation_player.play("popped")

func get_bubble_needed(time):
	return 1000 + 500 * log(1 + time)

func amount_complete():
	if not _completion_cooldown.timeout.is_connected(_on_completion_cooldown_timeout):
		_completion_cooldown.timeout.connect(_on_completion_cooldown_timeout)
	
	_animation_player.play("bubbled")
	_completion_cooldown.start()

func _on_completion_cooldown_timeout():
	initialize_amount_needed(_game.time)
