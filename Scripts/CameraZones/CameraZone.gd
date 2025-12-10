class_name CameraZone
extends Area3D

@onready var zone_manager = %CameraZoneManager
@onready var path: Path3D = $CameraPath
@onready var camera: Camera3D = $CameraPath/LockedCamera
@onready var player: Player = %Player

@export var CAMERA_FOLLOW_SPEED := 20.0

func body_shape_entered(_body_rid: RID, body: Node3D, _body_shape_index: int, _local_shape_index: int) -> void:
	if body is Player:
		zone_manager.current_zone = self
		player.get_camera().current = false
		camera.current = true

func body_shape_exited(_body_rid: RID, body: Node3D, _body_shape_index: int, _local_shape_index: int) -> void:
	if body is Player:
		if zone_manager.current_zone == self:
			zone_manager.current_zone = null
			camera.current = false
			player.get_camera().current = true


var target_position := Vector3.ZERO

func _ready() -> void:
	target_position = path.curve.get_point_position(0)

func _physics_process(delta: float) -> void:
	if zone_manager.current_zone != self:
		return

	if path.curve.get_point_count() == 0:
		return

	var player_local = path.to_local(player.global_transform.origin)
	var closest_offset: float = path.curve.get_closest_offset(player_local)
	var closest_point = path.curve.sample_baked(closest_offset)
	var target_global_position := path.to_global(closest_point)
	camera.global_transform.origin = camera.global_transform.origin.lerp(target_global_position, CAMERA_FOLLOW_SPEED * delta)
	camera.look_at(player.global_transform.origin, Vector3.UP)
		
