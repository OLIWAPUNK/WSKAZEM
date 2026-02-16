class_name CameraZone
extends Area3D

signal zone_entered(zone: CameraZone)
signal zone_exited(zone: CameraZone)

@onready var camera_path: Path3D = $CameraPath
@onready var locked_view: Camera3D = $LockedView

enum cameraType {FOLLOW, POINT, PATH}
@export var camera_type: cameraType = cameraType.FOLLOW

@export var camera_offset: Vector3

enum lockType {NONE, VERTICAL, HORIZONTAL, BOTH}
@export var lock_camera: lockType = lockType.NONE

@export_group("Smoothing")
enum smoothType {NONE, OUT, IN, BOTH}
@export var smoothing: smoothType = smoothType.NONE
@export var smoothing_priority: int = 0

@export_group("Player Movement")
@export_range(0, 360) var forward_angle: float = 0.0


func _ready() -> void:
	assert(camera_path.curve, "%s: CameraPath has no Curve defined" % self)
	assert(camera_path.curve.point_count > 0, "%s: CameraPath Curve has no points" % self)
	
	connect("body_shape_entered", body_entered_zone)
	connect("body_shape_exited", body_exited_zone)
	
	
func get_camera_position(target_point: Vector3) -> Vector3:
	
	match camera_type:
		
		cameraType.PATH:
			var curve_point_closest_to_target := camera_path.curve.get_closest_point(target_point) + camera_path.global_position
			return curve_point_closest_to_target + camera_offset
	
		cameraType.POINT:
			return locked_view.position + camera_offset
		
		cameraType.FOLLOW, _:
			return target_point + camera_offset
	

func disable_collisions() -> void:
	
	$CollisionShape3D.disabled = true

func body_entered_zone(_body_rid: RID, body: Node3D, 
		_body_shape_index: int, _local_shape_index: int) -> void:
	assert(body is CharacterBody3D, "Object entered zone that's not a CharacterBody3D")
	
	zone_entered.emit(self)
	#zone_manager.change_current_zone(self)


func body_exited_zone(_body_rid: RID, body: Node3D, 
		_body_shape_index: int, _local_shape_index: int) -> void:
	assert(body is CharacterBody3D, "Object exited zone that's not a CharacterBody3D")
	
	zone_exited.emit(self)
	#zone_manager.body_exited_zone(self)
