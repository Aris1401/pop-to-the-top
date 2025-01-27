extends BubbleRefiller
class_name Refiller

func _process(delta: float) -> void:
	$Label3D.text = str(len(machines_in_range))
