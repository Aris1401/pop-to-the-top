extends CanvasLayer
class_name UI

# References
@export var _bubble_count : Label

func set_bubble_count(amount):
	_bubble_count.text = var_to_str(amount)
