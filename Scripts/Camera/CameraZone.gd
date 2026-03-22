@tool
class_name CameraZone
extends Area3D

signal zone_entered(zone: CameraZone)
signal zone_exited(zone: CameraZone)

enum cameraType {POINT, PATH}
@export var camera_type: cameraType = cameraType.POINT:
	set(new_type):
		camera_type = new_type
		update_configuration_warnings()

@export var path_offset: Vector3 = Vector3.ZERO

@export_group("Rotation clamping")
@export var clamp_rotation: bool = false
@export_range(0, 180, 0.1, "radians_as_degrees") var clamp_up: float = 0
@export_range(-180, 0, 0.1, "radians_as_degrees") var clamp_down: float = 0
@export_range(0, 180, 0.1, "radians_as_degrees") var clamp_left: float = 0
@export_range(-180, 0, 0.1, "radians_as_degrees") var clamp_right: float = 0

var path: Path3D
var camera_node: Camera3D
var camera_default_transform: Transform3D
var clamp_full: bool = false
var zone_box: CollisionShape3D
var transmitter: GateTransmitter

var focus_mode: bool = false
var focus_view_positon: Vector3 = Vector3.ZERO


func _ready() -> void:

	if clamp_up == 0 and clamp_down == 0 and clamp_left == 0 and clamp_right == 0:
		clamp_full = true

	for node in get_children():
		if node is Camera3D:
			camera_node = node
		if node is Path3D:
			path = node
		if node is CollisionShape3D:
			zone_box = node
		if node is GateTransmitter:
			transmitter = node

	camera_default_transform = camera_node.transform

	if path:
		assert(path.curve, "%s: CameraPath has no Curve defined" % self)
		assert(path.curve.point_count > 0, "%s: CameraPath Curve has no points" % self)

	input_ray_pickable = false
	
	body_shape_entered.connect(body_entered_zone)
	body_shape_exited.connect(body_exited_zone)


func _get_configuration_warnings() -> PackedStringArray:

	var warnings: PackedStringArray = []

	var cameras: int = find_children("", "Camera3D").size()
	var paths: int = find_children("", "Path3D").size()
	var boxes: int = find_children("", "CollisionShape3D").size()

	if cameras == 0:
		warnings.append("No Camera3D")
	if cameras > 1:
		warnings.append("More than one Camera3D")

	if boxes > 1:
		warnings.append("More than one CollisionShape3D")

	if camera_type == cameraType.PATH:
		if paths == 0:
			warnings.append("No Path3D")
		elif paths > 1:
			warnings.append("More than one Path3D")
		else:		# WARNING to nie dziala bo nie przetwarza zmian w dzieciach
			var _path: Path3D = find_children("", "Path3D")[0]
			if not _path.curve:
				warnings.append("Path3D has no Curve3D")
			elif _path.curve.point_count == 0:
				warnings.append("Curve3D (in Path3D) has no points")

	return warnings


func update_position(target_point: Vector3) -> void:
	
	if focus_mode:
		camera_node.position = focus_view_positon
		return

	if camera_type == cameraType.POINT:
		return

	var position_on_path := path.curve.get_closest_point(target_point - path.global_position) + path.global_position
	camera_node.position = position_on_path + path_offset


func update_rotation(target_point: Vector3) -> void:

	if focus_mode or not clamp_rotation:
		camera_node.look_at(target_point)
		return

	if clamp_full:
		return

	var looking_transform: Transform3D = camera_default_transform.looking_at(target_point)
	var default_eurler: Vector3 = camera_default_transform.basis.get_euler()
	var difference: Vector3 = looking_transform.basis.get_euler() - default_eurler

	difference.x = clampf(difference.x, clamp_down, clamp_up)
	difference.y = clampf(difference.y, clamp_right, clamp_left)

	camera_node.rotation = default_eurler + difference
	

func disable_collisions() -> void:	
	zone_box.disabled = true


func body_entered_zone(_body_rid: RID, body: Node3D, _body_shape_index: int, _local_shape_index: int) -> void:
	assert(body is CharacterBody3D, "Object entered zone that's not a CharacterBody3D")
	zone_entered.emit(self)

	if transmitter:
		transmitter.gate_transmit(0)


func body_exited_zone(_body_rid: RID, body: Node3D, _body_shape_index: int, _local_shape_index: int) -> void:
	assert(body is CharacterBody3D, "Object exited zone that's not a CharacterBody3D")
	zone_exited.emit(self)