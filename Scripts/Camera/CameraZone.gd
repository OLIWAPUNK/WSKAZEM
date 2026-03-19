@tool
class_name CameraZone
extends Area3D

signal zone_entered(zone: CameraZone)
signal zone_exited(zone: CameraZone)

var path: Path3D
var camera_node: Camera3D
var zone_box: CollisionShape3D

enum cameraType {POINT, PATH}
@export var camera_type: cameraType = cameraType.POINT:
	set(new_type):
		camera_type = new_type
		update_configuration_warnings()

@export var path_offset: Vector3 = Vector3.ZERO

@export_group("Rotation clamping")
@export var clamp_rotation: bool = false
@export_range(0, 180, 0.1, "radians_as_degrees") var positive_dx: float = 0
@export_range(-180, 0, 0.1, "radians_as_degrees") var negative_dx: float = 0
@export_range(0, 180, 0.1, "radians_as_degrees") var positive_dy: float = 0
@export_range(-180, 0, 0.1, "radians_as_degrees") var negative_dy: float = 0


func _ready() -> void:

	for node in get_children():
		if node is Camera3D:
			camera_node = node
		if node is Path3D:
			path = node
		if node is CollisionShape3D:
			zone_box = node

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
	
	if camera_type == cameraType.POINT:
		return

	var position_on_path := path.curve.get_closest_point(target_point - path.global_position) + path.global_position
	camera_node.position = position_on_path + path_offset


func update_rotation(target_point: Vector3) -> void:

	var _looking_vector: Vector3 = target_point - camera_node.global_position
	camera_node.look_at(target_point)

	var _rotation_dx: float = 0
	var _rotation_dy: float = 0
	
	if clamp_rotation:
		pass # clamping

	# print(target_point)
	

func disable_collisions() -> void:	
	zone_box.disabled = true


func body_entered_zone(_body_rid: RID, body: Node3D, _body_shape_index: int, _local_shape_index: int) -> void:
	assert(body is CharacterBody3D, "Object entered zone that's not a CharacterBody3D")
	zone_entered.emit(self)


func body_exited_zone(_body_rid: RID, body: Node3D, _body_shape_index: int, _local_shape_index: int) -> void:
	assert(body is CharacterBody3D, "Object exited zone that's not a CharacterBody3D")
	zone_exited.emit(self)
