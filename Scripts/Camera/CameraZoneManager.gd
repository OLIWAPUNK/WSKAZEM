class_name CameraZoneManager
extends Node

@export var starting_camera_zone: CameraZone
@export var FORCE_STARTING_WHEN_UNDEFINED: bool = false

# @export_group("Movement Smoothing")
# @export_range(0.0, 1.0, 0.01) var SMOOTHING: float = 0.5


@onready var default_follow_target: Node3D = $"/root/World/PlayerNode/PlayerBody"
var follow_target: Node3D = null

var zone_stack: Array[CameraZone] = []
var current_zone: CameraZone


func _ready() -> void:
	assert(starting_camera_zone, "No starting CameraZone set in CameraZoneManager")
	assert(default_follow_target, "default_follow_target not found in CameraZoneManager")

	starting_camera_zone.disable_collisions()
	
	for child in get_children():
		if child is not CameraZone: 
			continue
		
		child.connect("zone_entered", body_entered_zone)
		child.connect("zone_exited", body_exited_zone)
		
	current_zone = starting_camera_zone
	follow_target = default_follow_target

	current_zone.camera_node.current = true

	Global.camera_zone_manager = self


func _physics_process(_delta: float) -> void:

	current_zone.update_position(follow_target.global_position)
	current_zone.update_rotation(follow_target.global_position)
	
	Global.debug.add_debug_property("Camera Location", current_zone.camera_node.global_transform.origin, 1)


func body_entered_zone(entered_zone: CameraZone) -> void:
	
	zone_stack.append(entered_zone)
	current_zone = entered_zone
	
	current_zone.camera_node.current = true
	

func body_exited_zone(exited_zone: CameraZone) -> void:
	assert(exited_zone in zone_stack, "Exiting not saved zone!")
	
	zone_stack.erase(exited_zone)
	if zone_stack.size() > 0:
		current_zone = zone_stack.back()
	elif FORCE_STARTING_WHEN_UNDEFINED:
		current_zone = starting_camera_zone

	current_zone.camera_node.current = true
	
	
func set_temporary_follow_target(new_follow_target: Node3D) -> void:
	follow_target = new_follow_target


func clear_temporary_follow_target() -> void:
	follow_target = default_follow_target

func focus(locked_view_position: Vector3) -> void:
	current_zone.focus_view_positon = locked_view_position
	current_zone.focus_mode = true

func unfocus():
	current_zone.focus_mode = false
	current_zone.focus_view_positon = Vector3.ZERO
	if current_zone.camera_type == current_zone.cameraType.POINT:
		current_zone.camera_node.transform = current_zone.camera_default_transform