extends Node

@onready var player_node: CharacterBody3D = $"../PlayerBody"

@export var MOVEMENT_SPEED: float = 1000
@export var GRAVITY: float = -300
@export_enum("Default", "Tank", "Relative") var CONTROLLS: String
@export_group("Tank Controlls")
@export var ROTATION_SPEED: float = 10

var forward_angle: float = 0
var previous_forward_angle: float = 0


func _ready() -> void:
	assert(player_node, "CharacterBody3D not found")


func get_input(delta: float) -> void:
	
	match CONTROLLS:
		"Tank":
			tank_movement(delta)
		"Relative":
			relative_movement(delta)
		_:
			default_movement(delta)
			

func new_camera_zone(new_zone: CameraZone) -> void:
	
	forward_angle = new_zone.forward_angle
	
				
func relative_movement(delta: float) -> void:
	
	var input_direction_2d := Input.get_vector("up", "down", "right", "left")
	if input_direction_2d == Vector2.ZERO:
		previous_forward_angle = forward_angle
	
	var input_direction_3d := Vector3(input_direction_2d.x, 0, input_direction_2d.y)
	input_direction_3d = input_direction_3d.rotated(Vector3.UP, deg_to_rad(previous_forward_angle))
	
	player_node.velocity = input_direction_3d * MOVEMENT_SPEED * delta


func tank_movement(delta: float) -> void:
	
	var input_direction_2d := Input.get_vector("up", "down", "right", "left")
	var input_direction_3d := input_direction_2d.x * player_node.global_transform.basis.z.normalized()
	var input_rotation_3d := Vector3(0, input_direction_2d.y, 0)
	
	player_node.rotation += input_rotation_3d * ROTATION_SPEED * delta
	player_node.velocity = input_direction_3d * MOVEMENT_SPEED * delta
	

func default_movement(delta: float) -> void:
	
	var input_direction_2d := Input.get_vector("up", "down", "right", "left")
	var input_direction_3d := Vector3(input_direction_2d.x, 0, input_direction_2d.y)
	
	player_node.velocity = input_direction_3d * MOVEMENT_SPEED * delta
	

func apply_gravity(delta: float) -> void:
	
	player_node.velocity.y = GRAVITY * delta
	

func _physics_process(delta: float) -> void:
	
	get_input(delta)
	apply_gravity(delta)
	player_node.move_and_slide()
