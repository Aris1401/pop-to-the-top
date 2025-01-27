extends CanvasLayer
class_name UI

@export var _animation_player : AnimationPlayer

# References
@export_subgroup("Player Interface")
@export var _player_interface : Control
@export var _bubble_count : Label
@export var _timer : Label 

@export var _bubble_amount_progress : TextureProgressBar

# Damage
@export_subgroup("Damage")
@export var _damage_progress_container : MarginContainer
@export var _damage_progress : TextureProgressBar
@export var _iminent_impact_pop_up : NinePatchRect
@export var _iminent_impact_timer : Label

# Machine shop
@export_subgroup("Machine Shop")
@export var _machine_shop : MachineShop

# Game Over
@export_subgroup("Game Over")
@export var _game_over_screen : GameOverScreen

# Pause menu
@export_subgroup("Pause")
@export var _pause_menu_screen : PauseMenu

# Machine menu
@export_subgroup("Machine Menu")
@export var _machine_menu : MachineMenu

# ------ Controls
@export_category("Player Controls")
@export var player_normal_controls_screen : VBoxContainer
@export var player_building_controls_screen : VBoxContainer

# Signals
# Player interface
signal player_interface_opened
signal player_interface_closed

# SHOP
signal shop_opened
signal shop_closed

# GAME OVER
signal game_over_opened
signal game_over_closed

# PAUSE
signal pause_opened
signal pause_closed

# MACHINE MENU
signal machine_menu_opened
signal machine_menu_closed

signal bought_item_from_shop(machine_item : MachineItemShopInformation)

func _ready() -> void:
	_machine_shop._ui = self
	_machine_shop.populate_machine_shop(0)
	
	_game_over_screen._ui = self
	
	# Connecting signals from the shop
	_machine_shop.bought_item.connect(_on_bought_item)
	
	# Connecting signals from machine menu
	_machine_menu.request_close.connect(hide_machine_menu_screen)
	
	# Hiding some menus at start
	_machine_shop.hide()
	_game_over_screen.hide()
	_pause_menu_screen.hide()
	_machine_menu.hide()

#region Player Interface
func hide_player_interface():
	_player_interface.hide()
	player_interface_closed.emit()

func show_player_interface():
	_player_interface.show()
	player_interface_opened.emit()
#endregion

#region Bubble Informations
func set_bubble_count(amount, required):
	_bubble_count.text =  var_to_str(roundi(amount)) + " / " + var_to_str(roundi(required))
	
	var tween = get_tree().create_tween()
	tween.tween_property(_bubble_amount_progress, "value", amount, 0.4).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	
	_machine_shop.update_machine_shop(amount)
#endregion 

#region Timer Informations
func set_timer(time):
	var msec = fmod(time, 1) * 1000
	var sec = fmod(time, 60)
	var min = time / 60
	
	var format_string = "%02d : %02d : %02d"
	_timer.text = format_string % [min, sec, msec]
#endregion

#region Asteroid Informations
func set_asteroid_amount(amount_needed):
	_bubble_amount_progress.max_value = amount_needed

func show_asteroid_amount():
	_bubble_amount_progress.show()

func hide_asteroid_amount():
	_bubble_amount_progress.hide()
#endregion

#region Shop
func show_shop():
	_machine_shop.show()
	shop_opened.emit()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
func hide_shop():
	_machine_shop.hide()
	shop_closed.emit()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _on_bought_item(machine_item : MachineItemShopInformation):
	bought_item_from_shop.emit(machine_item)
#endregion

#region Damage
func damage_dealt(damage, total_damage):
	_animation_player.play("damage_taken")
	
	if total_damage == 0:
		_damage_progress_container.hide()
	else:
		_damage_progress_container.show()
		
		var tween = get_tree().create_tween()
		tween.tween_property(_damage_progress, "value", total_damage, 0.5).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
#endregion

#region Game over
func show_game_over_screen(time_informations, max_bubble):
	_game_over_screen.show()
	_game_over_screen.set_score(time_informations, max_bubble)
	
	game_over_opened.emit()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func hide_game_over_screen():
	_game_over_screen.hide()
	game_over_closed.emit()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
#endregion

#region Player Controls
func show_player_normal_controls_screen():
	player_building_controls_screen.hide()
	player_normal_controls_screen.show()

func show_player_building_controls_screen():
	player_building_controls_screen.show()
	player_normal_controls_screen.hide()
#endregion

#region Pause Menu
func show_pause_menu_screen():
	_pause_menu_screen.show()
	pause_opened.emit()

func hide_pause_menu_screen():
	_pause_menu_screen.hide()
	pause_closed.emit()
#endregion

#region Iminent Impact
func show_iminent_impact_pop_up():
	_iminent_impact_pop_up.show()

func hide_iminent_impact_pop_up():
	_iminent_impact_pop_up.hide()

func update_iminent_impact_timer(time):
	var seconds = int(time)
	var milliseconds = int((time - seconds) * 100)
	_iminent_impact_timer.text = "%02d:%02d" % [seconds, int(milliseconds)]
#endregion

#region Machine Menu
func show_machine_menu_screen(machine : Machine):
	_machine_menu.show()
	_machine_menu.initialize(machine)
	machine_menu_opened.emit()

func hide_machine_menu_screen():
	_machine_menu.hide()
	_machine_menu.try_disconnect()
	machine_menu_closed.emit()
#endregion
