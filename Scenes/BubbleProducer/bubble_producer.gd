extends Node3D
class_name BubbleProducer

var _game : Game

# Etat du producer
enum BubbleProducerState {
	PRODUCING,
	IDLE,
	IMPOSSIBLE_STATE,
	BROKE
}
var current_state : BubbleProducerState = BubbleProducerState.IDLE
var last_state : BubbleProducerState

# Informations
@export_category("Bubble Producer Informations")
@export var bubble_rates : BaseBubbleRates
@export var breakdown_probability : float = 0.0
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

# Signals
signal state_changed(last_state : BubbleProducerState, next_state : BubbleProducerState)

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
	change_state(BubbleProducerState.PRODUCING)

func end():
	if (current_state != BubbleProducerState.PRODUCING):
		change_state(BubbleProducerState.IMPOSSIBLE_STATE)
		return
	
	_rate_timer.stop()
	
	if bubble_vfx:
		bubble_vfx.stop()
	
	if bubble_sfx:
		bubble_sfx.stop()
	
	if _animation_player:
		_animation_player.play(animation_idle_name)
	
	change_state(BubbleProducerState.IDLE)

func _on_rate_timer_timeout():
	if _game:
		_game.create_bubble(bubble_rates.bubble_amount * bubble_rates.bubble_multiplier, 10)
		
		if calculate_breakdown_probability():
			end()
			change_state(BubbleProducerState.BROKE)
		else:
			produce()

func repair():
	produce()

#region StateManager
func change_state(state : BubbleProducerState):
	state_changed.emit(current_state, state)
	
	last_state = current_state
	current_state = state

func check_for_impossible_state():
	var res = false
	
	if current_state == BubbleProducerState.IMPOSSIBLE_STATE:
		res = true
	
	change_state(BubbleProducerState.IDLE)
	return res

func get_state_str(state):
	if state == BubbleProducerState.PRODUCING:
		return "Producing"
	elif state == BubbleProducerState.IDLE:
		return "Idle"
	elif state == BubbleProducerState.IMPOSSIBLE_STATE:
		return "Impossible"
	else:
		return "Broke"
#endregion

#region Breakdown Probability
func calculate_breakdown_probability():
	randomize()
	
	var rnd = randf()
	
	return false if breakdown_probability == 0 else rnd <= breakdown_probability / 100.0
#endregion
