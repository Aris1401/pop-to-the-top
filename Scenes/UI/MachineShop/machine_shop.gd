extends Control
class_name MachineShop

@export var machine_shop_informations : Array[MachineItemShopInformation]

# References
@export var _machine_items_container : HBoxContainer
@export var _bubble_count_label : Label
var _ui : UI

# Packed Scenes
const MACHINE_ITEM_SHOP = preload("res://Scenes/UI/MachineItemShop/machine_item_shop.tscn")

# Signals
signal bought_item(machine_item : MachineItemShopInformation)

func populate_machine_shop(bubble_amount):
	_bubble_count_label.text = "Bubble: " + var_to_str(bubble_amount)
	
	for current_machine_items in _machine_items_container.get_children():
		current_machine_items.queue_free()
	
	for machine_item in machine_shop_informations:
		var machine_item_shop = MACHINE_ITEM_SHOP.instantiate()
		_machine_items_container.add_child(machine_item_shop)
		
		machine_item_shop.create(machine_item, self, bubble_amount)
		machine_item_shop.buy_item.connect(_on_buy_item)

func update_machine_shop(bubble_amount):
	_bubble_count_label.text = "Bubble: " + var_to_str(bubble_amount)
	
	for machine_item in _machine_items_container.get_children():
		if machine_item is MachineItemShop:
			machine_item.machine_buy.disabled = bubble_amount < machine_item._shop_informations.machine_bubble_price

func _on_buy_item(machine_item : MachineItemShop):
	bought_item.emit(machine_item._shop_informations)
