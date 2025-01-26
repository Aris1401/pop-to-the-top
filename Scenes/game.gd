extends Node3D
class_name Game

# Game states
enum GameStates {
	IN_GAME,
	IN_SHOP,
	OVER,
	PAUSED
}

var current_game_state : GameStates = GameStates.IN_GAME

# Game Properties
var bubble_amount : float = 0.0
var max_bubble_amount : float = 0.0
var total_damage : float = 0.0

# Managers
@export_category("Managers")
@export var damage_manager : DamageManager
@export var timer_manager : TimerManager

# References
@export_category("References")
@export var _player : Player
@export var _ui : UI
@export var _asteroid : Asteroid
@export var _damage_hit_sfx : AudioStreamPlayer3D

# Signals
signal bubble_amount_changed(amount, required)

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
		_player.state_changed.connect(_on_player_change_state)
		
		# Connecting player to the ui
		_player._player_inputs.request_cancel.connect(_on_request_ui_cancel)
	
	if _asteroid:
		_asteroid._game = self
		_asteroid.amount_needed_changed.connect(_on_asteroid_amount_needed_changed)
		
		_asteroid.initialize_amount_needed(timer_manager.time, get_machines_count())
	
	# Connecting signals to the UI
	bubble_amount_changed.connect(_ui.set_bubble_count)
	
	damage_manager.damage_dealt.connect(_ui.damage_dealt)
	
	# Connecting signals from the UI
	# SHOP
	_ui.shop_opened.connect(_on_shop_opened)
	_ui.shop_closed.connect(_on_shop_closed)
	_ui.bought_item_from_shop.connect(_on_bought_item_from_shop)
	
	# GAME OVER
	_ui.game_over_opened.connect(_on_game_over_screen_opened)
	_ui.game_over_closed.connect(_on_game_over_screen_closed)
	
	_ui._game_over_screen.request_retry.connect(_on_request_retry)
	
	# PAUSE MENU
	_ui._pause_menu_screen.request_continue.connect(_on_request_continue)
	
	_ui.pause_closed.connect(_on_pause_menu_closed)
	_ui.pause_opened.connect(_on_pause_menu_opened)
	
	# Connecting signals
	damage_manager.limit_reached.connect(_on_damage_limit_reached)
	damage_manager.damage_dealt.connect(_on_damage_dealt)

func game_state_to_str():
	match (current_game_state):
		0:
			return "In Game"
		1:
			return "In Shop"
		2:
			return "Game Over"

func _process(delta: float) -> void:
	_ui.set_timer(timer_manager.time)

#region BUBBLE
func create_bubble(amount, lifetime):
	bubble_amount += amount
	bubble_amount_changed.emit(bubble_amount, _asteroid.amount_needed)
	
	max_bubble_amount = max(max_bubble_amount, bubble_amount)
	
	var bubble = preload("res://Scenes/Bubble/bubble.tscn").instantiate()
	
	bubble.amount = amount
	bubble.lifetime = lifetime
	
	bubble.popped.connect(_on_bubble_popped)
	
	bubble.process_mode = Node.PROCESS_MODE_PAUSABLE
	
	self.add_child(bubble)
	bubble.start_lifetime()
	
	check_asteroid_completion()

func _on_bubble_popped(amount):
	bubble_amount -= amount
	if (bubble_amount < 0): bubble_amount = 0
	
	bubble_amount_changed.emit(bubble_amount, _asteroid.amount_needed)
#endregion

#region Asteroid
func _on_asteroid_amount_needed_changed(amount_needed):
	_ui.set_asteroid_amount(_asteroid.amount_needed)
	_ui.show_asteroid_amount()

# Permet de checker si le nombre de bulle que l'asteroide avait besoin a ete satisfait
func check_asteroid_completion():
	if _asteroid.amount_needed <= bubble_amount and _asteroid._completion_cooldown.is_stopped():
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

#region Machines
func get_machines_count():
	return len(get_tree().get_nodes_in_group("Machine"))
#endregion

#region Damage
func _on_damage_dealt(damage, total_damage):
	_player._camera_controller._shackable_camera.add_trauma(1.5)
	
	var rand_pos = get_random_position_around_player(_player.global_position, 20)
	_damage_hit_sfx.global_position = rand_pos
	_damage_hit_sfx.play()

func _on_damage_limit_reached():
	_ui.show_game_over_screen(timer_manager.get_time_information(), max_bubble_amount)

func get_random_position_around_player(player_position: Vector3, radius: float) -> Vector3:
	# Generate random spherical coordinates
	var theta = randf() * TAU  # Random angle around Y-axis (0 to 2π)
	var phi = acos(2.0 * randf() - 1.0)  # Random angle from Z-axis (0 to π)
	
	# Convert spherical coordinates to Cartesian coordinates
	var x = sin(phi) * cos(theta)
	var y = sin(phi) * sin(theta)
	var z = cos(phi)
	
	# Create the random offset vector
	var random_offset = Vector3(x, y, z) * randf() * radius
	
	# Add the offset to the player's position
	return player_position + random_offset
#endregion

#region Game Over Screen
func _on_game_over_screen_opened():
	current_game_state = GameStates.OVER
	
	# Close all 
	_ui.hide_player_interface()
	_ui.hide_shop()
	
	get_tree().paused = true

func _on_game_over_screen_closed():
	pass

func _on_request_retry():
	get_tree().paused = false
	get_tree().reload_current_scene()
#endregion

#region Pause Menu
func _on_request_continue():
	get_tree().paused = false
	_ui.hide_pause_menu_screen()
	
	# Open all
	_ui.show_player_interface()
	
func _on_pause_menu_opened():
	current_game_state = GameStates.PAUSED
	
	# Close all 
	_ui.hide_shop()
	
	get_tree().paused = true
	
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_pause_menu_closed():
	current_game_state = GameStates.IN_GAME
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
#endregion

#region Player States
func _on_player_change_state(last_state, next_state):
	if next_state == _player.PlayerStates.BUILDING:
		_ui.show_player_building_controls_screen()
		return
	if next_state == _player.PlayerStates.NORMAL:
		_ui.show_player_normal_controls_screen()
		return
#endregion

#region Inputs
func _on_request_ui_cancel():
	if (current_game_state == GameStates.PAUSED):
		_ui.hide_pause_menu_screen()
	elif (current_game_state != GameStates.PAUSED):
		_ui.show_pause_menu_screen()
#endregion
