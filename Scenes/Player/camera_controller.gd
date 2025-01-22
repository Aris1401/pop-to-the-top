extends Node3D
class_name CameraController

# Camera movement vectors
var mouse_movement : Vector2
var mouse_velocity_x : float
var mouse_velocity_y : float

# Camera properties
@export_category("Camera Properties")
@export var mouse_x_sensitivity : float = 0.5
@export var mouse_y_sensitivity : float = 0.5
@export var mouse_acceleration : float = 10
@export_subgroup("Camera X Deadzones")
@export var max_y_rotation = 90.0
@export var min_y_rotation = -90.0

# References
@export_category("References")
@export var _player : Player
@export var _camera : Camera3D

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(delta: float) -> void:
	if _player._player_inputs.ui_cancel:
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta: float) -> void:
	mouse_movement = _player._player_inputs.mouse_movement
	
	mouse_velocity_x = lerp(mouse_velocity_x, mouse_movement.y * mouse_x_sensitivity, delta * mouse_acceleration)
	mouse_velocity_y = lerp(mouse_velocity_y, mouse_movement.x * mouse_y_sensitivity, delta * mouse_acceleration)
	
	rotation.x -= deg_to_rad(mouse_velocity_x)
	_player.rotation.y -= deg_to_rad(mouse_velocity_y)
	
	rotation_degrees.x = clamp(rotation_degrees.x, min_y_rotation, max_y_rotation)
	
	_player._player_inputs.mouse_movement = Vector2()
