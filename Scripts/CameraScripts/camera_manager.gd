class_name CameraManager
extends Node

@export var default_camera_pivot: Node3D
@export var follow_point: Node3D

@onready var zone_manager: CameraZoneManager = $"../CameraZoneManager"
var current_zone: CameraZone = null


func _ready() -> void:
	assert(zone_manager, "Nie znaleziono")
	assert(default_camera_pivot, "Nie przypisano")
	assert(follow_point, "Nie przypisano")
	
	zone_manager.connect("zone_changed", new_camera_zone)
	

func camera_position() -> Vector3:
	
	if current_zone:
		return current_zone.get_closest_on_curve(follow_point.global_position)
	else:
		return default_camera_pivot.global_position


func camera_rotation_target() -> Vector3:
	
	if not current_zone or not current_zone.locked_view:
		return follow_point.global_position
	
	#var locked_normal := current_zone.locked_view.global_transform.basis.x
	var locked_normal := current_zone.locked_view.global_transform.basis.x
	#locked_normal = locked_normal.rotated(Vector3.UP, PI/2)
	#locked_normal.y = 0;
	
	var look_plane := Plane(locked_normal, camera_position())
	var target = look_plane.project(follow_point.global_position)
	$"../../DEBUGBITCH".position = target
	return target


func new_camera_zone(new_zone: CameraZone) -> void:
	
	current_zone = new_zone
	
	
	
