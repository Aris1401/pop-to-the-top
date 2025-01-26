extends Node3D
class_name ArmsController

# Propreites
var is_active : bool = true

# Bubble Producer
@export var bubble_producer : BubbleProducer

# References
@export var _player : Player

func _ready():
	_player._player_inputs.fired.connect(_on_fire)
	_player._player_inputs.stoped_fire.connect(_on_stopped_fire)
	_player.state_changed.connect(_on_player_state_changed)

func _on_fire():
	if _player._game.current_game_state != _player._game.GameStates.IN_GAME || not is_active:
		return
	
	if not bubble_producer._game:
		bubble_producer._game = _player._game
	
	_player._animation_controller.set_condition("Movement", "is_shooting", true)
	_player._animation_controller.set_condition("Movement", "stop_shooting", false)

func start_fire():
	if not is_active:
		return
	
	bubble_producer.produce()

func _on_stopped_fire():
	if not is_active:
		return
	
	if _player._game.current_game_state != _player._game.GameStates.IN_GAME:
		return
	
	_player._animation_controller.set_condition("Movement", "stop_shooting", true)
	_player._animation_controller.set_condition("Movement", "is_shooting", false)
	
	bubble_producer.end()

func _on_player_state_changed(last_state, next_state):
	if next_state != _player.PlayerStates.NORMAL:
		is_active = false
	else:
		is_active = true
