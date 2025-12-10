class_name CameraZone
extends Area3D

signal zone_entered(zone: CameraZone)
signal zone_exited(zone: CameraZone)

@onready var zone_manager = %CameraZoneManager
@onready var path: Path3D = $CameraPath
@onready var player: Player = %Player

func body_shape_entered(_body_rid: RID, body: Node3D, _body_shape_index: int, _local_shape_index: int) -> void:
	if body is Player:
		zone_manager.current_zone = self
		zone_entered.emit(self)

func body_shape_exited(_body_rid: RID, body: Node3D, _body_shape_index: int, _local_shape_index: int) -> void:
	if body is Player:
		if zone_manager.current_zone == self:
			zone_manager.current_zone = null
			zone_exited.emit(self)
		
