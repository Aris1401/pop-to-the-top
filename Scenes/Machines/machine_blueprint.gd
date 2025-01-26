extends Node3D
class_name MachineBlueprint

# Blueprint properties
var can_build : bool = true

@export var machine_scene : PackedScene

# References
@export_category("References")
@export var _placing_area : Area3D

@export var _valid_blueprint_mesh : Node3D
@export var _invalid_blueprint_mesh : Node3D

func _ready() -> void:
	_placing_area.body_entered.connect(_on_placing_area_body_entered)
	_placing_area.body_exited.connect(_on_placing_area_body_exited)

func build(game : Game):
	if machine_scene:
		var machine_instance : BubbleProducer = machine_scene.instantiate()
		game.add_child(machine_instance)
		
		machine_instance.global_position = global_position
		machine_instance.rotation_degrees = rotation_degrees
		machine_instance._game = game
	
	queue_free()

func rotate_blueprint():
	var next_rotation = Vector3(rotation_degrees.x, rotation_degrees.y + 90, rotation_degrees.z) 
	
	var tween = get_tree().create_tween()
	tween.tween_property(self, "rotation_degrees", next_rotation, 0.2).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)

func _on_placing_area_body_entered(body : Node3D):
	if body.is_in_group("Buildable"):
		return
	
	_valid_blueprint_mesh.hide()
	_invalid_blueprint_mesh.show()
	
	can_build = false

func _on_placing_area_body_exited(body : Node3D):
	if body.is_in_group("Buildable"):
		return
	
	_valid_blueprint_mesh.show()
	_invalid_blueprint_mesh.hide()
	
	can_build = true
