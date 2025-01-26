extends Node2D
class_name MenuSoundPlayer

@export var parent : Control

# Audios
@export_subgroup("Button")
@export var button_on_hover_sound : AudioStream
@export var button_on_click_sound : AudioStream

var sound_streams : Dictionary[String, AudioStreamPlayer] = {}

func _ready() -> void:
	if not parent:
		parent = owner
	
	init_player()
	
	var buttons = parent.get_children(true)
	
	for button in buttons:
		if button is Button:
			bind_button(button)

func init_player():
	var stream_player_clicked = AudioStreamPlayer.new()
	stream_player_clicked.stream = button_on_click_sound
	stream_player_clicked.bus = "Menu"
	
	var stream_player_hover = AudioStreamPlayer.new()
	stream_player_hover.stream = button_on_hover_sound
	stream_player_hover.bus = "Menu"
	
	add_child(stream_player_clicked)
	add_child(stream_player_hover)
	
	sound_streams["pressed"] = stream_player_clicked
	sound_streams["mouse_entered"] = stream_player_hover

func get_all_children(in_node,arr:=[]):
	arr.push_back(in_node)
	for child in in_node.get_children():
		arr = get_all_children(child,arr)
	return arr

func bind_button(button : Button):
	button.pressed.connect(play_sound.bind("pressed"))
	button.mouse_entered.connect(play_sound.bind("mouse_entered"))

func play_sound(sound_name):
	sound_streams[sound_name].play()
