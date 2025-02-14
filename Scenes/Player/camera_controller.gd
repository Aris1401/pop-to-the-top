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
@export_subgroup("Camera Tilt")
@export var enable_camera_tilt : bool = true
@export var camera_tilt_amount : float = 0.02

@export_subgroup("Arms Properties")
@export var _arms : Node3D
@export var enable_arms_tilt : bool = true
@export var amrs_tilt_amount : float = 0.02
@export var enable_arms_sway : bool = false
@export var arms_sway_amount : float = 0.01

# References
@export_category("References")
@export var _player : Player
@export var _camera : Camera3D
@export var _shackable_camera : ShackableCamera

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta: float) -> void:
	mouse_movement = _player._player_inputs.mouse_movement
	
	mouse_velocity_x = lerp(mouse_velocity_x, mouse_movement.y * mouse_x_sensitivity, delta * mouse_acceleration)
	mouse_velocity_y = lerp(mouse_velocity_y, mouse_movement.x * mouse_y_sensitivity, delta * mouse_acceleration)
	
	rotation.x -= deg_to_rad(mouse_velocity_x)
	_player.rotation.y -= deg_to_rad(mouse_velocity_y)
	
	rotation_degrees.x = clamp(rotation_degrees.x, min_y_rotation, max_y_rotation)
	
	_player._player_inputs.mouse_movement = Vector2()
	
	# Additions
	if enable_camera_tilt: camera_tilt(delta)
	if enable_arms_tilt: arms_tilt(delta)
	if enable_arms_sway: arms_sway(delta)

func create_ray(ray_distance):
	var space_state = get_world_3d().direct_space_state
	var mouse_position = get_viewport().get_mouse_position()
	
	var ray_origin = _camera.project_ray_origin(mouse_position)
	var end = ray_origin + _camera.project_ray_normal(mouse_position) * ray_distance
	
	var query = PhysicsRayQueryParameters3D.create(ray_origin, end)
	query.exclude = [_player]
	return space_state.intersect_ray(query)

func camera_tilt(delta):
	if _camera:
		_camera.rotation.z = lerp(_camera.rotation.z, -_player._player_inputs.player_direction.x * camera_tilt_amount, 10 * delta)

func arms_tilt(delta):
	if _arms:
		_arms.rotation.z = lerp(_arms.rotation.z, -_player._player_inputs.player_direction.x * amrs_tilt_amount, 10 * delta)

func arms_sway(delta):
	if _arms:
		_arms.rotation.x = lerp(_arms.rotation.x, mouse_velocity_y * arms_sway_amount, 10 * delta)
		_arms.rotation.y = lerp(_arms.rotation.y, mouse_velocity_x * arms_sway_amount, 10 * delta)
