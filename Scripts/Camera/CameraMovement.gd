class_name CameraMovement
extends Node

@onready var camera_manager: CameraManager = $"../../CameraManager"
@onready var camera_node: Camera3D = $".."

var current_zone: CameraZone = null

var camera_smoothing: bool = false
var rotation_target: Vector3 = Vector3.ZERO



func _ready() -> void:
	assert(camera_node, "Not found")
	assert(camera_node.current, "Main camera not active")
	assert(camera_manager, "Not found")


func _process(_delta: float) -> void:
	
	if camera_smoothing:
		camera_node.position = camera_node.position.slerp(get_camera_position(), camera_manager.SMOOTHING)
	else:
		camera_node.position = get_camera_position()
		camera_smoothing = true
		
	rotation_target = rotation_target.slerp(get_camera_rotation_target(), 0.1)
	camera_node.look_at(rotation_target) # WARNING


func get_camera_position() -> Vector3:
	
	var follow_point_target := camera_manager.follow_target.global_position
	return current_zone.get_camera_position(follow_point_target)
	
	
func get_camera_rotation_target() -> Vector3:
	
	if current_zone.lock_camera == current_zone.lockType.NONE:
		return camera_manager.follow_target.global_position
		
	if current_zone.lock_camera == current_zone.lockType.BOTH:
		var looking_direction := -current_zone.locked_view.get_camera_transform().basis.z
		var camera_position := camera_node.global_position
		
		return camera_position + looking_direction
	
	return calculate_rotation_with_locking()


func calculate_rotation_with_locking() -> Vector3:
	
	var locked_normal: Vector3
	if current_zone.lock_camera == current_zone.lockType.HORIZONTAL:
		locked_normal = current_zone.locked_view.global_transform.basis.x
	if current_zone.lock_camera == current_zone.lockType.VERTICAL:
		locked_normal = current_zone.locked_view.global_transform.basis.y
	
	var look_plane := Plane(locked_normal, get_camera_position())
	
	return look_plane.project(camera_manager.follow_target.global_position)


func new_camera_zone(new_zone: CameraZone) -> void:
	
	var smooth_in = (new_zone.smoothType in [CameraZone.smoothType.IN, CameraZone.smoothType.BOTH])
	var smooth_out = (current_zone.smoothType in [CameraZone.smoothType.OUT, CameraZone.smoothType.BOTH])
	
	if current_zone:
		if new_zone.smoothing_priority >= current_zone.smoothing_priority:
			camera_smoothing = smooth_in
		else:
			camera_smoothing = smooth_out
		
	print_debug("Switching camera zone to: " + new_zone.name)
	current_zone = new_zone
