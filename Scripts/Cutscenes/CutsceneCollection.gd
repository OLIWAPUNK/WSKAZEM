class_name CutsceneCollection
extends AnimationPlayer

@onready var camera_manager: CameraManager = %CameraNode/CameraManager

@export var cutscene_identifier: String
## Camera zone to use during the cutscene. If set, the camera zone will have its collisions disabled.
@export var camera_zone: CameraZone
@export var follow_target: Node3D
@export var disable_player_controls: bool = true

func _ready() -> void:

	assert(cutscene_identifier != null and cutscene_identifier != "", "Cutscene identifier must be set")

	if camera_zone:
		camera_zone.disable_collisions()

func play_cutscene(anim_name: String) -> Signal:
	
	assert(has_animation(anim_name), "Cutscene animation not found: " + anim_name)

	Global.player_controls_disabled = disable_player_controls

	if camera_zone:
		if follow_target:
			camera_manager.set_temporary_follow_target(follow_target)
		camera_zone.zone_entered.emit(camera_zone)

	animation_finished.connect(_on_animation_finished)
	play(anim_name)
	print_debug("Playing cutscene: " + cutscene_identifier + ", animation: " + anim_name)
	return animation_finished

func _on_animation_finished(_anim_name: String) -> void:
	print_debug("Cutscene finished: " + cutscene_identifier)
	Global.player_controls_disabled = false
	if camera_zone:
		camera_zone.zone_exited.emit(camera_zone)
		camera_manager.clear_temporary_follow_target()
