extends Node3D
class_name PlayerAnimationController

# References
@export var _player : Player
@export var _animation_tree : AnimationTree

func _process(delta: float) -> void:
	set_condition("Movement", "is_idle", _player.velocity.length() <= 0.1)
	set_condition("Movement", "is_walking", _player.velocity.length() > 0.1)

func set_condition(state_machine, condition, value):
	_animation_tree.set("parameters/"+ state_machine +"/conditions/" + condition, value)

func request_transition(transition_name, transition_to):
	_animation_tree.set("parameters/" + transition_name + "/transition_request", transition_to)
