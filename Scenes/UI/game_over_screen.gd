extends Control
class_name GameOverScreen

var _ui : UI

# References
@onready var time_score: Label = %TimeScore
@onready var bubble_score: Label = %BubbleScore
@onready var retry_button: Button = %RetryButton
@onready var menu_button: Button = %MenuButton

# Signals
signal request_retry

func _ready() -> void:
	retry_button.pressed.connect(_on_retry_button_clicked)
	menu_button.pressed.connect(_on_menu_button_clicked)

func set_score(time, max_bubbles):
	var format_string = "%02d:%02d"
	time_score.text = "Your time: " + format_string % [time.min, time.sec]
	bubble_score.text = "Max bubble: " + var_to_str(int(max_bubbles))

func _on_retry_button_clicked():
	request_retry.emit()

func _on_menu_button_clicked():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/UI/Menu/Main/main_menu.tscn")
