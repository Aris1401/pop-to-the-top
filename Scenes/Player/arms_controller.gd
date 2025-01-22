extends Node3D
class_name ArmsController

# Bubble Producer
@export var bubble_producer : BubbleProducer

# References
@export var _player : Player

func _ready():
	_player._player_inputs.fired.connect(_on_fire)
	_player._player_inputs.stoped_fire.connect(_on_stopped_fire)

func _on_fire():
	if not bubble_producer._game:
		bubble_producer._game = _player._game
	
	_player._animation_controller.set_condition("Movement", "is_shooting", true)
	_player._animation_controller.set_condition("Movement", "stop_shooting", false)

func start_fire():
	bubble_producer.produce()

func _on_stopped_fire():
	_player._animation_controller.set_condition("Movement", "stop_shooting", true)
	_player._animation_controller.set_condition("Movement", "is_shooting", false)
	
	bubble_producer.end()
