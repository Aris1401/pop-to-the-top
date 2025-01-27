extends Control
class_name MachineMenu

var current_machine : BubbleProducer

# References
@export var _close_button : Button
@export var _repair_button : Button

@export var _machine_name_label : Label

# Signals
signal request_close

func _ready() -> void:
	_close_button.pressed.connect(_on_close_button_clicked)
	_repair_button.pressed.connect(_on_repair_button_clicked)

func initialize(machine : BubbleProducer):
	if current_machine == machine:
		return
	
	current_machine = machine
	
	_machine_name_label.text = current_machine.bubble_rates.name
	
	_on_machine_state_changed(null, current_machine.current_state)
	
	current_machine.state_changed.connect(_on_machine_state_changed)
	
	set_process(true)

func try_disconnect():
	if current_machine:
		current_machine.state_changed.disconnect(_on_machine_state_changed)
		current_machine = null
	
	set_process(false)

func _on_close_button_clicked():
	request_close.emit()

func _on_repair_button_clicked():
	if current_machine:
		current_machine.repair()

func _on_machine_state_changed(last_state, next_state):
	if next_state == current_machine.BubbleProducerState.BROKE:
		_repair_button.text = "Repair"
		_repair_button.disabled = false
	
	if next_state == current_machine.BubbleProducerState.PRODUCING:
		_repair_button.text = "Producing..."
		_repair_button.disabled = true
