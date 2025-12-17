class_name CameraZoneManager
extends Node

signal zone_changed(new_zone: CameraZone)

@onready var camera_manager: CameraManager = $"../CameraManager"

var zones_list: Array[CameraZone] = []
var current_zone_stack: Array[CameraZone] = []
var current_zone: CameraZone


func _ready() -> void:
	assert(camera_manager, "Not found")
	
	for child in get_children():
		if child is not CameraZone: 
			continue
				
		zones_list.append(child)
		
		child.connect("zone_entered", body_entered_zone)
		child.connect("zone_exited", body_exited_zone)
		
	current_zone = camera_manager.default_camera_zone
	zone_changed.emit(current_zone)
	

func body_entered_zone(entered_zone: CameraZone) -> void:
	
	current_zone_stack.append(entered_zone)
	
	if current_zone:
		if current_zone.smoothing_priority > entered_zone.smoothing_priority:
			return
			
	current_zone = entered_zone
	zone_changed.emit(current_zone)
	

# WARNING Sprawdzanie priority przy wychodzeniu ważne???
func body_exited_zone(exited_zone: CameraZone) -> void:
	assert(exited_zone in current_zone_stack, "Exiting not saved zone!")
	
	current_zone_stack.erase(exited_zone)
	if current_zone_stack.size() > 0:
		current_zone = current_zone_stack.back()
	else:
		current_zone = camera_manager.default_camera_zone
	
	zone_changed.emit(current_zone)
	
