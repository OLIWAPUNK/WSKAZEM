class_name CameraZoneManager
extends Node

signal zone_changed(new_zone: CameraZone)

var zones_list: Array[CameraZone] = []
var current_zone: CameraZone


func _ready() -> void:
	
	for child in get_children():
		if child is CameraZone:
			
			child.connect("body_shape_entered", child.body_entered_zone)
			child.connect("body_shape_exited", child.body_exited_zone)
			
			zones_list.append(child)


func change_current_zone(entered_zone: CameraZone) -> void:
	
	current_zone = entered_zone
	zone_changed.emit(current_zone)
	
	
func body_exited_zone(exited_zone: CameraZone) -> void:
	
	if (exited_zone == current_zone):
		current_zone = null
		zone_changed.emit(current_zone)
	
