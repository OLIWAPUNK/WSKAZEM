extends CharacterBody3D

@export var MOVEMENT_SPEED := 8
@export var ROTATION_SPEED := 5
@export var JUMP_IMPULSE:= 20
@export var fall_acceleration := 75

var rotation_angle = Vector3.ZERO

func _ready() -> void:
	rotation_angle = rotation

func _physics_process(delta: float) -> void:
	if is_on_floor():
		var input_direction_2d = Input.get_vector("left", "right" , "up", "down")
		var movement_angle_offset: float = $"../Camera".rotation.y
		input_direction_2d = input_direction_2d.rotated(-movement_angle_offset)
		var input_direction_3d = Vector3(input_direction_2d.x, 0, input_direction_2d.y)
		velocity = input_direction_3d.normalized() * MOVEMENT_SPEED
	
		if Input.is_action_just_pressed('jump'):
			velocity.y = JUMP_IMPULSE
	else:
		velocity.y = velocity.y - (fall_acceleration * delta)
		
	if (abs(velocity.x) > 0.01 || abs(velocity.z) > 0.01):
		var target_angle = atan2(velocity.x, velocity.z)
		rotation_angle.y = lerp_angle(rotation.y, target_angle, delta * ROTATION_SPEED)
		
	rotation = rotation_angle
		
	move_and_slide()
