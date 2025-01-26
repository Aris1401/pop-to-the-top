extends Node3D
class_name BuildingManager

var is_active : bool = false

# Building properties
var current_build : MachineItemShopInformation
var machine_blueprint : MachineBlueprint

# Bulding ray properties
@export_category("Building Ray Properties")
@export var building_distance : float = 300

var building_point : Vector3

# References
@export_category("References")
@export var _player : Player
@export var _building_cooldown_timer : Timer

func _ready() -> void:
	set_process(false)
	
	_player.state_changed.connect(_on_player_state_changed)
	_player._player_inputs.fired.connect(_on_fire)
	_player._player_inputs.request_rotate.connect(_on_request_rotate)
	
	_building_cooldown_timer.timeout.connect(_on_building_cooldown_timeout)

func start_building(machine_item : MachineItemShopInformation):
	if current_build:
		return
	
	_player.change_state(_player.PlayerStates.BUILDING)
	current_build = machine_item
	
	set_process(true)
	
	# Instantiating the blueprint
	if not machine_item.machine_blueprint:
		printerr("State invalid")
	
	machine_blueprint = machine_item.machine_blueprint.instantiate()
	_player._game.add_child(machine_blueprint)

func _process(delta: float) -> void:
	if machine_blueprint:
		var ray_results = _player._camera_controller.create_ray(building_distance)
		if ray_results:
			building_point = ray_results.position
			machine_blueprint.position = building_point

func free_building():
	machine_blueprint = null
	current_build = null
	
	_building_cooldown_timer.start()

func _on_fire():
	if is_active:
		if machine_blueprint and machine_blueprint.can_build:
			machine_blueprint.build(_player._game)
			free_building()

func _on_request_rotate():
	if is_active:
		if machine_blueprint:
			machine_blueprint.rotate_blueprint()

func _on_building_cooldown_timeout():
	_player.change_state(_player.PlayerStates.NORMAL)
	_building_cooldown_timer.stop()

func _on_player_state_changed(last_state, next_state):
	if next_state == _player.PlayerStates.BUILDING:
		is_active = true
	else:
		is_active = false
