extends StaticBody3D
class_name Asteroid

var amount_needed : float = 0.0

# Asteroind properties
@export var have_limit : bool = true
@export var limit_wait_time : float = 12
@export var damage_over_time : float = 10
@export var damage_frequency : float = 5

# References
var _game : Game

@export_category("References")
@export var _completion_cooldown : Timer
@export var _limit_timer : Timer
@export var _damage_timer : Timer
@export var _animation_player : AnimationPlayer
@export var _bubble_particles : GPUParticles3D

# Signals
signal amount_needed_changed(amount_needed)

func emit_bubbles():
	_bubble_particles.emitting = true

func initialize_amount_needed(time, machines_count):
	if _game:
		if not _damage_timer.is_stopped():
			_damage_timer.stop()
		
		if not _limit_timer.is_stopped():
			_limit_timer.stop()
		
		amount_needed = get_bubble_needed(time, machines_count)
		amount_needed_changed.emit(amount_needed)
		
		_animation_player.play("popped")
		
		# Starting the limit timer
		if not _limit_timer.timeout.is_connected(_on_limit_timer_timeout):
			_limit_timer.timeout.connect(_on_limit_timer_timeout)
		
		_limit_timer.wait_time = limit_wait_time
		if have_limit:
			_limit_timer.start()

func get_bubble_needed(time, machines_count):
	return 1000 + 500 * machines_count * log(1 + time)

func amount_complete():
	if not _completion_cooldown.timeout.is_connected(_on_completion_cooldown_timeout):
		_completion_cooldown.timeout.connect(_on_completion_cooldown_timeout)
	
	_animation_player.play("bubbled")
	_completion_cooldown.start()
	
	if not _damage_timer.is_stopped():
		_damage_timer.stop()

func _on_completion_cooldown_timeout():
	initialize_amount_needed(_game.timer_manager.time, _game.get_machines_count())

func _on_limit_timer_timeout():
	start_damage()

func start_damage():
	_damage_timer.wait_time = damage_frequency
	
	if not _damage_timer.timeout.is_connected(_on_damage_timer_timeout):
		_damage_timer.timeout.connect(_on_damage_timer_timeout)
	
	_damage_timer.start()

func _on_damage_timer_timeout():
	_game.damage_manager.do_damage(damage_over_time)
