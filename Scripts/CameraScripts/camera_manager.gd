class_name CameraManager
extends Node

@onready var camera_movement: CameraMovement = $"../Camera/CameraMovement"
@onready var player_movement := $"../../PlayerNode/PlayerMovement"
@onready var zone_manager: CameraZoneManager = $"../CameraZoneManager"

@export var default_camera_zone: CameraZone
@export var follow_point: Node3D

@export_group("Movement Smoothing")
@export_range(0.0, 1.0, 0.01) var SMOOTHING: float = 0.5



func _ready() -> void:
	assert(zone_manager, "Not found")
	assert(default_camera_zone, "Not set")
	assert(follow_point, "Not set")
	
	zone_manager.connect("zone_changed", camera_movement.new_camera_zone)
	zone_manager.connect("zone_changed", player_movement.new_camera_zone)
	default_camera_zone.disable_collisions()
	default_camera_zone.smoothing_priority = int(-INF)
	
	
