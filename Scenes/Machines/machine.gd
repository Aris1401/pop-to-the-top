extends Node3D
class_name Machine

# Game Reference
var _game : Game

@export_subgroup("Base Information")
@export var machine_name : String

# Breaking Down
@export_subgroup("Breaking Down")
@export var breaking_down_probability : float = 0.0

# State Machine
enum MachineStates {
	IDLE,
	WORKING,
	IMPOSSIBLE,
	BROKE
}

var current_state : MachineStates = MachineStates.IDLE
var last_state : MachineStates

# Signal 
signal state_changed (last_sate : MachineStates, next_state : MachineStates)

func _ready():
	pass

func start_machine():
	pass

func stop_machine():
	pass

func breakdown():
	stop_machine()
	change_state(MachineStates.BROKE)

func repair():
	start_machine()

#region State Machine
func change_state(next_state : MachineStates):
	state_changed.emit(current_state, next_state)
	
	last_state = current_state
	current_state = next_state

func get_state_str(state):
	if state == MachineStates.WORKING:
		return "Working"
	elif state == MachineStates.IDLE:
		return "Idle"
	elif state == MachineStates.IMPOSSIBLE:
		return "Impossible"
	else:
		return "Broke"

func check_for_impossible_state():
	var res = false
	
	if current_state == MachineStates.IMPOSSIBLE:
		res = true
	
	change_state(MachineStates.IDLE)
	return res
#endregion

#region Breakdown Probability
func calculate_breakdown_probability():
	randomize()
	
	var rnd = randf()
	
	return false if breaking_down_probability == 0 else rnd <= breaking_down_probability / 100.0
#endregion
