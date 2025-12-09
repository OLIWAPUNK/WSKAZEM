extends Node3D

@export var MOUSE_SENSITIVITY := 0.005
@export_range(-90.0, 0.0, 0.1, "radians_as_degrees") var MIN_VERTICAL_ANGLE := -PI / 2
@export_range(0.0, 90.0, 0.1, "radians_as_degrees") var MAX_VERTICAL_ANGLE := PI / 4
@export var ZOOM_SPEED := 10.0
@export var ROTATION_SPEED := 20.0

@onready var spring_arm := $SpringArm3D

var target_spring_length: float
var target_rotation: Vector3

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	target_spring_length = spring_arm.spring_length
	target_rotation = rotation

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		target_rotation.y -= event.relative.x * MOUSE_SENSITIVITY
		target_rotation.y = wrapf(target_rotation.y, 0.0, TAU)

		target_rotation.x -= event.relative.y * MOUSE_SENSITIVITY
		target_rotation.x = clamp(target_rotation.x, MIN_VERTICAL_ANGLE, MAX_VERTICAL_ANGLE)

	if event.is_action_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			
	if Input.is_action_pressed("zoom_in"):
		target_spring_length -= 1.0
		target_spring_length = max(2.0, target_spring_length)
	if Input.is_action_pressed("zoom_out"):
		target_spring_length += 1.0
		target_spring_length = min(10.0, target_spring_length)

func _physics_process(_delta: float) -> void:
	global_position = $"..".global_position
	spring_arm.spring_length = lerp(spring_arm.spring_length, target_spring_length, ZOOM_SPEED * _delta)
	rotation.x = lerp_angle(rotation.x, target_rotation.x, ROTATION_SPEED * _delta)
	rotation.y = lerp_angle(rotation.y, target_rotation.y, ROTATION_SPEED * _delta)

	Global.debug.add_debug_property("Camera Zoom", snapped(1.0 - Util.normalize(spring_arm.spring_length, 2.0, 10.0), 0.01), 1)
	Global.debug.add_debug_property("Camera Rotation X", snapped(rad_to_deg(rotation.x), 0.01), 1)
	Global.debug.add_debug_property("Camera Rotation Y", snapped(rad_to_deg(rotation.y), 0.01), 1)