extends Node
class_name DebugManager

@export var _game : Game

func _process(delta: float) -> void:
	ImGui.Begin("Debug Panel")
	
	ImGui.Text("Damage")
	if (not _game.damage_manager.immunity and ImGui.Button("Disable Damage")):
		_game.damage_manager.immunity = true
	
	if (_game.damage_manager.immunity and ImGui.Button("Enable Damage")):
		_game.damage_manager.immunity = false
	
	if (ImGui.Button("Reset Damage")):
		_game.damage_manager.reset_damage()
	
	if (ImGui.Button("End Game")):
		_game.damage_manager.do_damage(1000)
	
	ImGui.Text("Bubbles")
	if (ImGui.Button("+100000 Bubbles")):
		_game.create_bubble(100000, 100)
	
	ImGui.End()
