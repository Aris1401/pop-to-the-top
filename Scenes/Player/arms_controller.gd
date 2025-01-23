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
	if _player._game.current_game_state == _player._game.GameStates.IN_SHOP:
		return
	
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

func _process(delta: float) -> void:
	ImGui.Begin("Bubble Maker State")
	ImGui.Text("Last State: " + var_to_str(bubble_producer.last_state))
	ImGui.Text("Current State: " + var_to_str(bubble_producer.current_state))
	ImGui.End()
