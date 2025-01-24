extends BubbleProducer
class_name Bubbler

func _ready() -> void:
	produce()

func _process(delta: float) -> void:
	$Label3D.text = "State: " + var_to_str(current_state)
