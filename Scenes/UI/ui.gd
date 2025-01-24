extends CanvasLayer
class_name UI

# References
@export var _bubble_count : Label
@export var _timer : Label 

@export var _bubble_amount_progress : TextureProgressBar

# Machine shop
@export var _machine_shop : MachineShop

# Signals
# SHOP
signal shop_opened
signal shop_closed

signal bought_item_from_shop(machine_item : MachineItemShopInformation)

func _ready() -> void:
	_machine_shop._ui = self
	_machine_shop.populate_machine_shop(0)
	
	# Connecting signals from the shop
	_machine_shop.bought_item.connect(_on_bought_item)

#region Bubble Informations
func set_bubble_count(amount):
	_bubble_count.text = var_to_str(amount)
	_bubble_amount_progress.value = amount
	
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
