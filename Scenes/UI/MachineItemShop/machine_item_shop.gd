extends MarginContainer
class_name MachineItemShop

@onready var machine_image: TextureRect = $VBoxContainer/MachineImage
@onready var machine_name: Label = $VBoxContainer/MachineName
@onready var machine_description: Label = $VBoxContainer/MachineDescription
@onready var button: Button = $VBoxContainer/Button

# References
var _machine_shop : MachineShop

func create(image, name, description, machine_shop):
	machine_name.text = name
	machine_description.text = description
	
	_machine_shop = machine_shop
