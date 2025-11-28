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
	

func get_camera_position() -> Vector3:
	
	if current_zone:
		return current_zone.get_closest_on_curve(follow_point.global_position)
	else:
		return default_camera_pivot.global_position


func calculate_rotation_with_locking():
	
	var locked_normal: Vector3
	if current_zone.LOCK_VERTICAL_ROTATION:
		locked_normal = current_zone.locked_view.global_transform.basis.x
	if current_zone.LOCK_HORIZONTAL_ROTATION:
		locked_normal = current_zone.locked_view.global_transform.basis.y
	
	var look_plane := Plane(locked_normal, get_camera_position())
	
	return look_plane.project(follow_point.global_position)
	
	
func get_camera_rotation_target() -> Vector3:
	
	var no_locked := not current_zone or not current_zone.locked_view
	if no_locked:
		return follow_point.global_position
		
	var totally_locked := (
			current_zone.LOCK_HORIZONTAL_ROTATION and 
			current_zone.LOCK_VERTICAL_ROTATION
	)
	if totally_locked:
		var looking_direction := -current_zone.locked_view.get_camera_transform().basis.z
		var camera_position := current_zone.locked_view.global_position
		
		return camera_position + looking_direction
	
	return calculate_rotation_with_locking()


func new_camera_zone(new_zone: CameraZone) -> void:
	
	current_zone = new_zone
	
	
	
