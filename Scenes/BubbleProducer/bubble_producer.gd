extends Node3D
class_name BubbleProducer

var _game : Game

# Informations
@export var bubble_rates : BaseBubbleRates
@export var bubble_vfx : BubbleVFX

# References
@export var _rate_timer : Timer

func produce():
	if not _rate_timer.timeout.is_connected(_on_rate_timer_timeout):
		_rate_timer.timeout.connect(_on_rate_timer_timeout)
	
	_rate_timer.wait_time = bubble_rates.bubble_rate
	_rate_timer.start()
	
	if bubble_vfx:
		bubble_vfx.start()

func end():
	_rate_timer.stop()
	
	if bubble_vfx:
		bubble_vfx.stop()

func _on_rate_timer_timeout():
	if _game:
		_game.create_bubble(bubble_rates.bubble_amount * bubble_rates.bubble_multiplier, 10)
		produce()
