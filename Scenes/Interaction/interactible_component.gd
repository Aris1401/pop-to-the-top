extends Area3D
class_name InteractibleComponent

@export var max_distance : float = 10.0

# Signals
signal interacted
signal is_out_of_range

func interact():
	interacted.emit()

func out_of_range():
	is_out_of_range.emit()
