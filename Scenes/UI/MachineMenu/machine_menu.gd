extends Control
class_name MachineMenu

var current_machine : Machine

# References
@export var _close_button : Button
@export var _repair_button : Button
@export var _fuel_bar : TextureProgressBar

@export var _machine_name_label : Label

# Signals
signal request_close

func _ready() -> void:
	_close_button.pressed.connect(_on_close_button_clicked)
	_repair_button.pressed.connect(_on_repair_button_clicked)

func initialize(machine : Machine):
	if current_machine == machine:
		return
	
	current_machine = machine
	_machine_name_label.text = current_machine.bubble_rates.name
	
	_on_machine_state_changed(null, current_machine.current_state)
	current_machine.state_changed.connect(_on_machine_state_changed)

	if current_machine._fuel_component:
		current_machine._fuel_component.fuel_amount_changed.connect(_on_fuel_amount_changed)
		_on_fuel_amount_changed(current_machine._fuel_component.fuel_current_amount)
	
	set_process(true)

func try_disconnect():
	if current_machine:
		current_machine.state_changed.disconnect(_on_machine_state_changed)
		
		if current_machine._fuel_component:
			current_machine._fuel_component.fuel_amount_changed.disconnect(_on_fuel_amount_changed)
		
		current_machine = null
	
	set_process(false)

func _on_close_button_clicked():
	request_close.emit()

func _on_repair_button_clicked():
	if current_machine:
		current_machine.repair()

func _on_machine_state_changed(last_state, next_state):
	if next_state == current_machine.MachineStates.BROKE:
		_repair_button.text = "Repair"
		_repair_button.disabled = false
	
	if next_state == current_machine.MachineStates.WORKING:
		_repair_button.text = "Producing..."
		_repair_button.disabled = true
	
	if next_state == current_machine.MachineStates.OUT_OF_FUEL:
		_repair_button.text = "Out of fuel"
		_repair_button.disabled = true

func _on_fuel_amount_changed(amount):
	var tween = get_tree().create_tween()
	tween.tween_property(_fuel_bar, "value", amount, 0.5)
