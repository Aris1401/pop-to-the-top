extends Node3D
class_name Game

# Game
var bubble_amount : float = 0.0

# References
@export var _player : Player
@export var _ui : UI

# Signals
signal bubble_amount_changed(amount)

func _ready() -> void:
	if not _player:
		for child in get_children():
			if child is Player:
				_player = child
	
	if _player:
		_player._game = self
	
	# Connecting signals to the UI
	bubble_amount_changed.connect(_ui.set_bubble_count)

func create_bubble(amount, lifetime):
	bubble_amount += amount
	bubble_amount_changed.emit(bubble_amount)
	
	var bubble = preload("res://Scenes/Bubble/bubble.tscn").instantiate()
	
	bubble.amount = amount
	bubble.lifetime = lifetime
	
	bubble.popped.connect(_on_bubble_popped)
	
	self.add_child(bubble)
	bubble.start_lifetime()

func _on_bubble_popped(amount):
	bubble_amount -= amount
	if (bubble_amount < 0): bubble_amount = 0
	
	bubble_amount_changed.emit(bubble_amount)
