extends Node
class_name Bubble

var amount : float = 0.0
var lifetime : float = 1.0

# References
@export var lifetime_timer : Timer

# Signals
signal popped(amount : float)

func _ready() -> void:
	lifetime_timer.wait_time = lifetime
	
	lifetime_timer.timeout.connect(_on_timeout)

func start_lifetime():
	lifetime_timer.start()

func _on_timeout():
	popped.emit(amount)
	queue_free()
