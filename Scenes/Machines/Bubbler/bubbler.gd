extends BubbleProducer
class_name Bubbler

func _ready() -> void:
	produce()

func _process(delta: float) -> void:
	$Label3D.text = get_state_str(current_state)

func _on_interactible_component_interacted() -> void:
	_game.request_machine_menu.emit(self)
