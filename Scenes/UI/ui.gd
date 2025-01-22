extends CanvasLayer
class_name UI

# References
@export var _bubble_count : Label
@export var _timer : Label 

@export var _bubble_amount_progress : TextureProgressBar

func set_bubble_count(amount):
	_bubble_count.text = var_to_str(amount)
	
	_bubble_amount_progress.value = amount

func set_timer(time):
	var msec = fmod(time, 1) * 1000
	var sec = fmod(time, 60)
	var min = time / 60
	
	var format_string = "%02d : %02d : %02d"
	_timer.text = format_string % [min, sec, msec]

#region Asteroid
func set_asteroid_amount(amount_needed):
	_bubble_amount_progress.max_value = amount_needed

func show_asteroid_amount():
	_bubble_amount_progress.show()

func hide_asteroid_amount():
	_bubble_amount_progress.hide()
#endregion
