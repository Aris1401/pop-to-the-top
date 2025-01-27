extends Node3D
class_name InteractionComponent

# References
@export var interaction_ray : RayCast3D
@export var _player : Player

# Buffers
var collided_object : InteractibleComponent

# Signals
signal is_interatible(object : Node3D)
signal is_out_of_range(object : Node3D)

func _ready() -> void:
	_player._player_inputs.interacted.connect(interact)

func _process(delta: float) -> void:
	if collided_object:
		var distance = collided_object.global_position.distance_to(self.global_position)
		
		if distance > collided_object.max_distance:
			collided_object.out_of_range()
			collided_object = null
			
			is_out_of_range.emit()

func interact():
	if interaction_ray.is_colliding():
		var collider = interaction_ray.get_collider()
		
		if collider is InteractibleComponent:
			collided_object = collider
			is_interatible.emit(collided_object)
	else:
		collided_object = null
		is_interatible.emit(null)
	
	if collided_object:
		collided_object.interact()
