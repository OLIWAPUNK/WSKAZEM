class_name CameraManager
extends Node

@onready var camera_movement: CameraMovement = $"../Camera/CameraMovement"
@onready var zone_manager: CameraZoneManager = $"../CameraZoneManager"

@export var default_camera_zone: CameraZone
@onready var default_follow_target: Node3D = $"/root/World/PlayerNode/PlayerBody"
var follow_target: Node3D = null

@export_group("Movement Smoothing")
@export_range(0.0, 1.0, 0.01) var SMOOTHING: float = 0.5



func _ready() -> void:
	assert(zone_manager, "Not found")
	assert(default_follow_target, "Not set")
	follow_target = default_follow_target

	if default_camera_zone == null:
		default_camera_zone = zone_manager.get_children()[0] as CameraZone
		assert(default_camera_zone, "No default camera zone set and no zones found in zone manager!")
		print_debug("No default camera zone set, using first found zone: ", default_camera_zone.name)

	zone_manager.connect("zone_changed", camera_movement.new_camera_zone)
	default_camera_zone.disable_collisions()
	default_camera_zone.smoothing_priority = int(-INF)
	


func _physics_process(_delta: float) -> void:

	Global.debug.add_debug_property("Camera Location", camera_movement.camera_node.global_transform.origin, 1)

func set_temporary_follow_target(new_follow_target: Node3D) -> void:
	follow_target = new_follow_target

func clear_temporary_follow_target() -> void:
	follow_target = default_follow_target
