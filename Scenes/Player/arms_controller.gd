extends Node3D
class_name ArmsController

# Propreites
var is_active : bool = true
var is_shooting : bool = false
var was_shooting : bool = false

# Bubble Producer
@export var bubble_producer : BubbleProducer

# References
@export var _player : Player
@export var _bm_animation_player : AnimationPlayer

func _ready():
	_player._player_inputs.fired.connect(_on_fire)
	_player._player_inputs.stoped_fire.connect(_on_stopped_fire)
	_player.state_changed.connect(_on_player_state_changed)

func _on_fire():
	if _player._game.current_game_state != _player._game.GameStates.IN_GAME || not is_active:
		return
	
	if not bubble_producer._game:
		bubble_producer._game = _player._game
	
	is_shooting = true
	
	_player._animation_controller.set_condition("Movement", "is_shooting", true)
	_player._animation_controller.set_condition("Movement", "stop_shooting", false)

func start_fire():
	if not is_active:
		return
	
	if not is_shooting:
		return
	
	was_shooting = true
	bubble_producer.produce()

func _on_stopped_fire():
	if not is_active:
		return
	
	if _player._game.current_game_state != _player._game.GameStates.IN_GAME:
		return
	
	_player._animation_controller.set_condition("Movement", "stop_shooting", true)
	_player._animation_controller.set_condition("Movement", "is_shooting", false)
	
	is_shooting = false

func stop_fire():
	if not is_active:
		return
	
	if not was_shooting:
		return
	bubble_producer.end()
	was_shooting = false

func call_bubble_maker_wind_up():
	_bm_animation_player.play("BubbleMaker_001|BM_wind_up")

func call_bubble_maker_shoot():
	_bm_animation_player.play("BubbleMaker_001|BM_shoot")

func call_bubble_maker_end_shoot():
	_bm_animation_player.play("BubbleMaker_001|BM_end_shoot")

func _on_player_state_changed(last_state, next_state):
	if next_state != _player.PlayerStates.NORMAL:
		is_active = false
	else:
		is_active = true
