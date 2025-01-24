extends CanvasLayer
class_name UI

# References
@export var _bubble_count : Label
@export var _timer : Label 

@export var _bubble_amount_progress : TextureProgressBar

# Damage
@export var _damage_progress_container : MarginContainer
@export var _damage_progress : TextureProgressBar

# Player Interface
@export var _player_interface : Control

# Machine shop
@export var _machine_shop : MachineShop

# Game Over
@export var _game_over_screen : GameOverScreen

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

signal bought_item_from_shop(machine_item : MachineItemShopInformation)

func _ready() -> void:
	_machine_shop._ui = self
	_machine_shop.populate_machine_shop(0)
	
	_game_over_screen._ui = self
	
	# Connecting signals from the shop
	_machine_shop.bought_item.connect(_on_bought_item)

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
