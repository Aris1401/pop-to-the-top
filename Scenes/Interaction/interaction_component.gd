extends Node3D
class_name InteractionComponent

# References
@export var interaction_ray : RayCast3D
@export var _player : Player

# Buffers
var collided_object : InteractibleComponent

# Signals
signal is_interatible(object : Node3D)

func _ready() -> void:
	_player._player_inputs.interacted.connect(interact)

func _process(delta: float) -> void:
	if interaction_ray.is_colliding():
		var collider = interaction_ray.get_collider()
		
		if collider is InteractibleComponent:
			collided_object = collider
			is_interatible.emit(collided_object)
	else:
		collided_object = null
		is_interatible.emit(null)

func interact():
	if collided_object:
		collided_object.interact()
