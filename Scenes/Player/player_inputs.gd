extends Node3D
class_name PlayerInputs

# Player Movement
var player_direction : Vector2

# Camera Movement
var mouse_movement : Vector2

# Basic inputs
var ui_cancel : bool

# Signals
signal fired
signal stoped_fire
signal shop

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse_movement = event.relative

func _process(delta: float) -> void:
	player_direction = Input.get_vector("left", "right", "fwd", "backward")
	
	ui_cancel = Input.is_action_just_pressed("ui_cancel")
	
	if (Input.is_action_just_pressed("fire")): fired.emit()
	if (Input.is_action_just_released("fire")): stoped_fire.emit()
	if (Input.is_action_just_pressed("shop")): shop.emit()
