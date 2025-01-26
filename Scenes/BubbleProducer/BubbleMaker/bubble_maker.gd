extends BubbleProducer
class_name BubbleMaker

#func _process(delta: float) -> void:
	#ImGui.Begin("Bubble Producer")
	#ImGui.SetWindowSize(Vector2(300, 100))
	#ImGui.Text("Current state: " + get_state_str(current_state))
	#ImGui.Text("Last state: " + get_state_str(last_state))
	#ImGui.End()
