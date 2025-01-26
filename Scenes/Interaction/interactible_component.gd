extends Area3D
class_name InteractibleComponent

# Signals
signal interacted

func interact():
	interacted.emit()
