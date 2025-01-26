extends MarginContainer
class_name MachineItemShop

@onready var machine_image: TextureRect = %MachineImage
@onready var machine_name: Label = %MachineName
@onready var machine_description: RichTextLabel = %MachineDescription
@onready var machine_buy: Button = %MachineBuy

# Stored data
var _shop_informations : MachineItemShopInformation

# References
var _machine_shop : MachineShop

# Signals
signal buy_item(machine_item : MachineItemShop)

func create(shop_informations : MachineItemShopInformation, machine_shop, bubble_amount : float):
	machine_name.text = shop_informations.machine_name
	machine_description.text = shop_informations.machine_description
	
	_machine_shop = machine_shop
	_shop_informations = shop_informations
	
	if bubble_amount < shop_informations.machine_bubble_price:
		machine_buy.disabled = true
	
	machine_buy.text = str(int(shop_informations.machine_bubble_price))
	machine_buy.pressed.connect(_on_machine_buy_clicked)

func _on_machine_buy_clicked():
	buy_item.emit(self)
