extends Node3D
class_name BubbleProducer

var _game : Game

# Etat du producer
enum BubbleProducerState {
	PRODUCING,
	IDLE,
	IMPOSSIBLE_STATE
}
var current_state : BubbleProducerState = BubbleProducerState.IDLE
var last_state : BubbleProducerState

# Informations
@export var bubble_rates : BaseBubbleRates
@export var bubble_vfx : BubbleVFX
@export var bubble_sfx : AudioStreamPlayer3D

# References
@export var _rate_timer : Timer

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
	
	# Changing the state
	change_state(BubbleProducerState.PRODUCING)

func end():
	if current_state == BubbleProducerState.IDLE || current_state == BubbleProducerState.IMPOSSIBLE_STATE:
		change_state(BubbleProducerState.IMPOSSIBLE_STATE)
		return
	
	_rate_timer.stop()
	
	if bubble_vfx:
		bubble_vfx.stop()
	
	if bubble_sfx:
		bubble_sfx.stop()
	
	change_state(BubbleProducerState.IDLE)

func _on_rate_timer_timeout():
	if _game:
		_game.create_bubble(bubble_rates.bubble_amount * bubble_rates.bubble_multiplier, 10)
		produce()

#region StateManager
func change_state(state : BubbleProducerState):
	last_state = current_state
	current_state = state

func check_for_impossible_state():
	if current_state == BubbleProducerState.IMPOSSIBLE_STATE:
		change_state(BubbleProducerState.IDLE)
		return true
	return false
#endregion
