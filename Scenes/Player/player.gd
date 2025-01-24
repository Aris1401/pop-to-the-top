extends CharacterBody3D
class_name Player

var _game : Game

# Player state
enum PlayerStates {
	NORMAL,
	BUILDING
}

var current_state : PlayerStates

signal state_changed(last_state : PlayerStates, next_state : PlayerStates)

# Player movement properties
@export_category("Player Movement")
@export var player_speed : float = 8.0
@export var player_acceleration : float = 13.0

var current_player_acceleration : float 

# Player movement vectors
var horizontal_movement : Vector3 = Vector3()

# References
@export_category("References")
@export var _player_inputs : PlayerInputs
@export var _animation_controller : PlayerAnimationController
@export var _building_manager : BuildingManager
@export var _camera_controller : CameraController 

func _ready() -> void:
	current_player_acceleration = player_acceleration

func _physics_process(delta: float) -> void:
	var direction = _player_inputs.player_direction
	
	var converted_direction = transform.basis * Vector3(direction.x, 0, direction.y)
	converted_direction = converted_direction.normalized()
	
	horizontal_movement = lerp(horizontal_movement, converted_direction * player_speed, delta * current_player_acceleration)
	velocity = horizontal_movement
	
	move_and_slide()

#region Player states
func change_state(next_state : PlayerStates):
	state_changed.emit(current_state, next_state)
	current_state = next_state
#endregion
