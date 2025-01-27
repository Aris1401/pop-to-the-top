extends Machine
class_name BubbleRefiller

# Properties
@export var refiller_rates : BaseRefillerRates

var machines_in_range : Array[BubbleProducer] = []
var machine_timers : Dictionary[BubbleProducer, Timer] = {}

func _ready():
	_game.placed_build.connect(_on_placed_build)
	start_machine()

func start_machine():
	check_in_radius()

func check_in_radius():
	var shape_rid = PhysicsServer3D.sphere_shape_create()
	PhysicsServer3D.shape_set_data(shape_rid, refiller_rates.refiller_radius)
	
	var params = PhysicsShapeQueryParameters3D.new()
	params.shape_rid = shape_rid
	params.transform = global_transform
	params.exclude = [self]
	
	var space = get_world_3d().direct_space_state
	var results = space.intersect_shape(params)
	
	for body in results:
		var collider = body.collider
		if collider is BubbleProducer:
			if collider not in machines_in_range:
				if collider._fuel_component:
					machines_in_range.append(body.collider)
	
	PhysicsServer3D.free_rid(shape_rid)

func _on_machine_state_changed(last_state, next_state, machine : BubbleProducer):
	if next_state == machine.MachineStates.OUT_OF_FUEL:
		var timer = Timer.new()
		timer.wait_time = refiller_rates.refiller_rates
		
		add_child(timer)
		
		timer.timeout.connect(_on_rate_timer_timeout.bind(machine))
		timer.start()
		
		machine_timers[machine] = timer
	
	if next_state == machine.MachineStates.WORKING:
		if machine in machine_timers:
			var timer = machine_timers[machine]
			
			timer.stop()
			timer.queue_free()
			
			machine_timers.erase(machine)

func _on_rate_timer_timeout(machine : BubbleProducer):
	machine._fuel_component.refuel(refiller_rates.refiller_amount * refiller_rates.refiller_multiplier)

func _on_placed_build(machine : Machine):
	if machine is not BubbleProducer:
		return
	
	if not machine._fuel_component:
		return
	
	if machine._fuel_component.assigned_refiller:
		return
	
	var distance = machine.global_position.distance_squared_to(global_position)
	if distance <= refiller_rates.refiller_radius:
		machines_in_range.append(machine)
