extends CanvasLayer
class_name MainMenu

var game_path := "res://Scenes/game.tscn"
var progress = []
var scene_load_status = 0

var is_loading : bool = false

# References
@export var _play_button : Button
@export var _quit_button : Button
@export var _how_to_button : Button

@export var _menu_screen : MarginContainer

@export var _how_to_screen : MarginContainer

@export var _progress_screen : MarginContainer
@export var _progress_bar : TextureProgressBar

func _ready() -> void:
	_play_button.pressed.connect(_on_play_button_clicked)
	_quit_button.pressed.connect(_on_quit_button_clicked)

func _on_play_button_clicked():
	get_tree().paused = false
	
	_menu_screen.hide()
	_how_to_screen.hide()
	
	_progress_screen.show()
	
	ResourceLoader.load_threaded_request(game_path)
	is_loading = true

func _process(delta: float) -> void:
	if is_loading:
		scene_load_status = ResourceLoader.load_threaded_get_status(game_path, progress)
		_progress_bar.value = floor(progress[0] * 100)
		
		if scene_load_status == ResourceLoader.THREAD_LOAD_LOADED:
			var game_scene = ResourceLoader.load_threaded_get(game_path)
			get_tree().change_scene_to_packed(game_scene)

func _on_quit_button_clicked():
	get_tree().quit()
