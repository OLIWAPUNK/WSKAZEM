extends Node

@onready var camera_manager: CameraManager = $"../../CameraManager"
@onready var camera_node: Camera3D = $".."

var current_zone: Area3D


func _ready() -> void:
	assert(camera_node, "Nie znaleziono")
	assert(camera_manager, "Nie znaleziono")


func _process(_delta: float) -> void:
	
	camera_node.position = camera_manager.camera_position()
	camera_node.look_at(camera_manager.camera_rotation_target())
	
	
