extends Machine
class_name BubbleProducer

# Informations
@export_category("Bubble Producer Informations")
@export var bubble_rates : BaseBubbleRates
@export_subgroup("FX")
@export var bubble_vfx : BubbleVFX
@export var bubble_sfx : AudioStreamPlayer3D
@export_subgroup("Animations")
@export var _animation_player : AnimationPlayer
@export var animation_producing_name : StringName
@export var animation_idle_name : StringName

# References
@export_category("References")
@export var _rate_timer : Timer

func start_machine():
	produce()

func stop_machine():
	end()

func produce():
	if not is_in_group("Machine"):
		add_to_group("Machine")
	
	if check_for_impossible_state():
		return
	
	if not _rate_timer.timeout.is_connected(_on_rate_timer_timeout):
		_rate_timer.timeout.connect(_on_rate_timer_timeout)
	
	_rate_timer.wait_time = bubble_rates.bubble_rate
	_rate_timer.start()
	
	if bubble_vfx:
		bubble_vfx.start()
	
	if bubble_sfx and not bubble_sfx.playing:
		bubble_sfx.play()
	
	if _animation_player:
		if not (_animation_player.current_animation == animation_producing_name and _animation_player.is_playing()):
			_animation_player.play(animation_producing_name)
	
	# Changing the state
	change_state(MachineStates.WORKING)

func end():
	if (current_state != MachineStates.WORKING):
		change_state(MachineStates.IMPOSSIBLE)
		return
	
	_rate_timer.stop()
	
	if bubble_vfx:
		bubble_vfx.stop()
	
	if bubble_sfx:
		bubble_sfx.stop()
	
	if _animation_player:
		_animation_player.play(animation_idle_name)
	
	change_state(MachineStates.IDLE)

func _on_rate_timer_timeout():
	if _game:
		_game.create_bubble(bubble_rates.bubble_amount * bubble_rates.bubble_multiplier, 10)
		
		if calculate_breakdown_probability():
			breakdown()
		else:
			start_machine()
