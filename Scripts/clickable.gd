extends Node

@onready var parent := $".."



func _ready() -> void:
	
	parent.connect("input_event", clickable_clicked)


func on_hover() -> void:

	pass


func clickable_clicked(_camera: Node, _event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:

	on_hover()
	
	if Input.is_action_just_pressed("go_to_point"):

		print(parent)