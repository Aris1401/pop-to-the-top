extends Node
class_name TimerManager

var time : float = 0.0

func _process(delta: float) -> void:
	update_time(delta)

func update_time(delta):
	time += delta

func get_time_information():
	var msec = fmod(time, 1) * 1000
	var sec = fmod(time, 60)
	var minu = time / 60
	
	return {
		"msec": msec,
		"sec": sec,
		"min": minu
	}

func reset_time():
	time = 0.0
