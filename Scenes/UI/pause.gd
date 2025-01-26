extends Control
class_name PauseMenu

@onready var continue_button: Button = %ContinueButton
@onready var main_menu_button: Button = %MainMenuButton

# Siganls 
signal request_continue

func _ready() -> void:
	continue_button.pressed.connect(_on_continue_button_pressed)
	main_menu_button.pressed.connect(_on_main_menu_button_pressed)

func _on_continue_button_pressed():
	request_continue.emit()

func _on_main_menu_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/UI/Menu/Main/main_menu.tscn")
