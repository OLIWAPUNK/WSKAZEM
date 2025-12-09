extends Node3D

@export var MOUSE_SENSITIVITY := 0.005
@export_range(-90.0, 0.0, 0.1, "radians_as_degrees") var MIN_VERTICAL_ANGLE := -PI / 2
@export_range(0.0, 90.0, 0.1, "radians_as_degrees") var MAX_VERTICAL_ANGLE := PI / 4

@onready var spring_arm := $SpringArm3D

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotation.y -= event.relative.x * MOUSE_SENSITIVITY
		rotation.y = wrapf(rotation.y, 0.0, TAU)

		rotation.x -= event.relative.y * MOUSE_SENSITIVITY
		rotation.x = clamp(rotation.x, MIN_VERTICAL_ANGLE, MAX_VERTICAL_ANGLE)

	if event.is_action_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			
	if Input.is_action_pressed("zoom_in"):
		spring_arm.spring_length -= 1.0
		spring_arm.spring_length = max(2.0, spring_arm.spring_length)
	if Input.is_action_pressed("zoom_out"):
		spring_arm.spring_length += 1.0
		spring_arm.spring_length = min(10.0, spring_arm.spring_length)

func _physics_process(_delta: float) -> void:
	global_position = $"..".global_position
