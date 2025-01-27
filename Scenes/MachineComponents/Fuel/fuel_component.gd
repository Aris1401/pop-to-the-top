extends Node
class_name FuelComponent

var _owner : Machine

# Fuel Properties
@export var fuel_max_amount : float = 100.0
var fuel_current_amount : float = fuel_max_amount

# Signals
signal fuel_amount_changed(amount)
signal out_of_fuel

func _ready() -> void:
	fuel_current_amount = fuel_max_amount

	if owner is not Machine:
		print("FuelComponent: Owner is not a Machine")
		return
	else:
		_owner = owner
	
	if _owner:
		_owner._fuel_component = self
		out_of_fuel.connect(_owner._on_out_of_fuel)

func consume_fuel(amount : float) -> void:
	fuel_current_amount -= amount

	if fuel_current_amount <= 0:
		fuel_current_amount = 0
		out_of_fuel.emit()
	
	fuel_amount_changed.emit(fuel_current_amount)
	
