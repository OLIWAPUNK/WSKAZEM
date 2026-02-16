class_name Cutscene
extends AnimationPlayer

@onready var camera_manager: CameraManager = %CameraNode/CameraManager

## Camera zone to use during the cutscene. If set, the camera zone will have its collisions disabled.
@export var camera_zone: CameraZone
@export var follow_target: Node3D
@export var disable_player_controls: bool = true

func _ready() -> void:
	if camera_zone:
		camera_zone.disable_collisions()
		if follow_target:
			camera_manager.set_temporary_follow_target(follow_target)

func play_cutscene() -> Signal:
	Global.player_controls_disabled = disable_player_controls
	if camera_zone:
		camera_zone.zone_entered.emit(camera_zone)
	animation_finished.connect(_on_animation_finished)
	play()
	return animation_finished

func _on_animation_finished() -> void:
	Global.player_controls_disabled = false
	if camera_zone:
		camera_zone.zone_exited.emit(camera_zone)
		camera_manager.clear_temporary_follow_target()