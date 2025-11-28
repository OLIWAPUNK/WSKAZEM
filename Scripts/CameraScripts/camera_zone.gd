class_name CameraZone
extends Area3D

@export var LOCK_VERTICAL_ROTATION: bool = false
@export var LOCK_HORIZONTAL_ROTATION: bool = false

@export var locked_view: Camera3D

@onready var zone_manager: CameraZoneManager = $".."
@onready var zone_path: Path3D = $CameraPath


func _ready() -> void:
	assert(zone_manager, "Nie znaleziono")
	assert(zone_path, "Nie znaleziono")
	
	if locked_view:
		locked_view.current = false
	
	
func get_closest_on_curve(target_point: Vector3) -> Vector3:
	
	return zone_path.curve.get_closest_point(target_point) + zone_path.global_position


func body_entered_zone(_body_rid: RID, body: Node3D, _body_shape_index: int, _local_shape_index: int) -> void:
	assert(body is CharacterBody3D, "Do Zone trafił inny obiekt niż CharacterBody3D")
	
	zone_manager.change_current_zone(self)


func body_exited_zone(_body_rid: RID, body: Node3D, _body_shape_index: int, _local_shape_index: int) -> void:
	assert(body is CharacterBody3D, "Zone opuścił inny obiekt niż CharacterBody3D")
	
	zone_manager.body_exited_zone(self)
