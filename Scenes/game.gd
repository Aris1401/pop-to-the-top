extends Node3D
class_name Game

var time : float = 0.0

# Game states
enum GameStates {
	IN_GAME,
	IN_SHOP
}

var current_game_state : GameStates = GameStates.IN_GAME

# Game Properties
var bubble_amount : float = 0.0

# References
@export var _player : Player
@export var _ui : UI
@export var _asteroid : Asteroid

# Signals
signal bubble_amount_changed(amount)

func _ready() -> void:
	if not _player:
		for child in get_children():
			if child is Player:
				_player = child
	
	if not _asteroid:
		_asteroid = get_tree().get_first_node_in_group("Asteroid")
	
	if _player:
		_player._game = self
		_player._player_inputs.shop.connect(_on_shop_pressed)
	
	if _asteroid:
		_asteroid._game = self
		_asteroid.amount_needed_changed.connect(_on_asteroid_amount_needed_changed)
		
		_asteroid.initialize_amount_needed(time)
	
	# Connecting signals to the UI
	bubble_amount_changed.connect(_ui.set_bubble_count)
	
	# Connecting signals from the UI
	# SHOP
	_ui.shop_opened.connect(_on_shop_opened)
	_ui.shop_closed.connect(_on_shop_closed)
	_ui.bought_item_from_shop.connect(_on_bought_item_from_shop)

func game_state_to_str():
	match (current_game_state):
		0:
			return "In Game"
		1:
			return "In Shop"

func _process(delta: float) -> void:
	update_time(delta)
	
	ImGui.Begin("Game State")
	ImGui.Text("Game state: " + game_state_to_str())
	ImGui.End()

#region TIME
func update_time(delta):
	time += delta
	_ui.set_timer(time)

func get_time_information():
	var msec = fmod(time, 1) * 1000
	var sec = fmod(time, 60)
	var min = time / 60
	
	return {
		"msec": msec,
		"sec": sec,
		"min": min
	}

func reset_time():
	time = 0.0
#endregion

#region BUBBLE
func create_bubble(amount, lifetime):
	bubble_amount += amount
	bubble_amount_changed.emit(bubble_amount)
	
	var bubble = preload("res://Scenes/Bubble/bubble.tscn").instantiate()
	
	bubble.amount = amount
	bubble.lifetime = lifetime
	
	bubble.popped.connect(_on_bubble_popped)
	
	self.add_child(bubble)
	bubble.start_lifetime()
	
	check_asteroid_completion()

func _on_bubble_popped(amount):
	bubble_amount -= amount
	if (bubble_amount < 0): bubble_amount = 0
	
	bubble_amount_changed.emit(bubble_amount)
#endregion

#region Asteroid
func _on_asteroid_amount_needed_changed(amount_needed):
	_ui.set_asteroid_amount(_asteroid.amount_needed)
	_ui.show_asteroid_amount()

# Permet de checker si le nombre de bulle que l'asteroide avait besoin a ete satisfait
func check_asteroid_completion():
	if _asteroid.amount_needed <= bubble_amount:
		_ui.hide_asteroid_amount()
		_asteroid.amount_complete()
#endregion

#region Shop Manager
func _on_shop_pressed():
	if current_game_state == GameStates.IN_GAME:
		_ui.show_shop()
	else:
		_ui.hide_shop()

func _on_shop_opened():
	current_game_state = GameStates.IN_SHOP

func _on_shop_closed():
	current_game_state = GameStates.IN_GAME

func _on_bought_item_from_shop(machine_item : MachineItemShopInformation):
	_player._building_manager.start_building(machine_item)
	_ui.hide_shop()
#endregion
