extends Node3D

@export var MOVEMENT_SPEED: int = 10

var MOVEMENT_ANGLE_OFFSET: float


func get_input():
	
	var input_direction_2d = Input.get_vector("up", "down", "right", "left")
	
	MOVEMENT_ANGLE_OFFSET = $"../CameraNode".rotation.y
	input_direction_2d = input_direction_2d.rotated(-MOVEMENT_ANGLE_OFFSET)
	
	var input_direction_3d = Vector3(input_direction_2d.x, 0, input_direction_2d.y)
	
	$PlayerBody.velocity = input_direction_3d * MOVEMENT_SPEED
	

func _physics_process(_delta: float) -> void:
	
	get_input()
	$PlayerBody.move_and_slide()
