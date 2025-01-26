extends BubbleProducer
class_name Bubbler

func _ready() -> void:
	produce()

func _process(delta: float) -> void:
	$Label3D.text = get_state_str(current_state)
