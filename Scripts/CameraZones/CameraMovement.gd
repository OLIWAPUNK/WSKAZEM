extends Camera3D

@onready var camera_zone: CameraZone = $'../..'
@onready var path: Path3D = $'..'
@onready var player: Player = %Player

@export var CAMERA_FOLLOW_SPEED := 20.0

func _ready() -> void:
	camera_zone.connect("zone_entered", self._on_zone_entered)
	camera_zone.connect("zone_exited", self._on_zone_exited)

func _on_zone_entered(_zone: CameraZone) -> void:
	player.get_camera().current = false
	current = true

func _on_zone_exited(_zone: CameraZone) -> void:
	current = false
	player.get_camera().current = true

func _physics_process(delta: float) -> void:
	if not current:
		return

	if path.curve.get_point_count() == 0:
		return

	var player_local = path.to_local(player.global_transform.origin)
	var closest_offset: float = path.curve.get_closest_offset(player_local)
	var closest_point = path.curve.sample_baked(closest_offset)
	var target_global_position := path.to_global(closest_point)
	global_transform.origin = global_transform.origin.lerp(target_global_position, CAMERA_FOLLOW_SPEED * delta)
	look_at(player.global_transform.origin, Vector3.UP)