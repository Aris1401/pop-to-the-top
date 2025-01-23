extends Control
class_name MachineShop

@export var machine_shop_informations : Array[MachineItemShopInformation]

# References
@export var _machine_items_container : HBoxContainer
var _ui : UI

# Packed Scenes
const MACHINE_ITEM_SHOP = preload("res://Scenes/UI/MachineItemShop/machine_item_shop.tscn")

func populate_machine_shop():
	for machine_item in machine_shop_informations:
		var machine_item_shop = MACHINE_ITEM_SHOP.instantiate()
		_machine_items_container.add_child(machine_item_shop)
		
		machine_item_shop.create(machine_item.machine_image, machine_item.machine_name, machine_item.machine_description, self)
