extends CharacterBody3D

@export var ACCELERATION := 8
@export var DECELERATION := 10
@export var SPEED := 10
@export var ROTATION_SPEED := 10
@export var JUMP_HEIGHT := 10
@export var GRAVITY_MULTIPLIER := 3.5
@export_range(0.0, 1.0, 0.05) var AIR_CONTROL := 0.3

@onready var rotation_angle: Vector3 = rotation
@onready var gravity: float = (ProjectSettings.get_setting("physics/3d/default_gravity") 
		* GRAVITY_MULTIPLIER)

var direction := Vector3()

func get_direction():
	var input_axis = Input.get_vector("left", "right" , "up", "down")
	# var movement_angle_offset: float = get_viewport().get_camera_3d().rotation.y
	# var rotated_axis = input_axis.rotated(-movement_angle_offset)
	# direction = Vector3(rotated_axis.x, 0, rotated_axis.y).normalized()
	direction = Vector3(input_axis.x, 0, input_axis.y).normalized()
	direction = direction.rotated(Vector3.UP, get_viewport().get_camera_3d().global_rotation.y)
	
func accelerate(delta: float):
	var temp_vel := velocity
	temp_vel.y = 0
	
	var temp_accel: float
	var target: Vector3 = direction * SPEED
	
	if direction.dot(temp_vel) > 0:
		temp_accel = ACCELERATION
	else:
		temp_accel = DECELERATION
	
	if not is_on_floor():
		temp_accel *= AIR_CONTROL
	
	temp_vel = temp_vel.lerp(target, temp_accel * delta)
	
	velocity.x = temp_vel.x
	velocity.z = temp_vel.z
	
func rotate_to_velocity(delta: float):
	if (abs(velocity.x) > 0.01 || abs(velocity.z) > 0.01):
		var target_angle = atan2(velocity.x, velocity.z)
		rotation_angle.y = lerp_angle(rotation.y, target_angle, delta * ROTATION_SPEED)
		
	rotation = rotation_angle

func _physics_process(delta: float) -> void:
	get_direction()

	if is_on_floor():
		if Input.is_action_just_pressed('jump'):
			velocity.y = JUMP_HEIGHT
	else:
		velocity.y -= gravity * delta
		
	accelerate(delta)
	
	Global.debug.add_debug_property("Velocity", snapped(velocity.length(), 0.01), 1)
		
	rotate_to_velocity(delta)
	
	move_and_slide()
