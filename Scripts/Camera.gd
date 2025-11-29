extends Camera3D

@export var TARGET: Node3D
@export var DIAGONAL_OFFSET := 16
@export var FOLLOW_SPEED := 5

@export var ZOOM_SPEED := 10
@export var ZOOM_FACTOR := 1.2

@export var MIN_SIZE := 20.0
@export var MAX_SIZE := 50.0

@export var MIN_ROTATION := -40
@export var MAX_ROTATION := -15

@export var MIN_ZOOM_POSSITON_OFFSET := -10
@export var MAX_ZOOM_POSITION_OFFSET := 10

@export var EDGE_THRESHOLD := 0.2
@export var EDGE_MOVE_SPEED := Vector2(.5, 1.5)

var target_size := 0.0
var target_rot := 0.0
var zoom_position_offset := 0
var edge_move_offset := Vector3.ZERO

func _ready():
	target_size = size
	target_rot = rotation_degrees.x

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("zoom_in"):
		target_size = clamp(target_size / ZOOM_FACTOR, MIN_SIZE, MAX_SIZE)
		

	if Input.is_action_just_pressed("zoom_out"):
		target_size = clamp(target_size * ZOOM_FACTOR, MIN_SIZE, MAX_SIZE)

	size = lerp(size, target_size, delta * ZOOM_SPEED)
	
	var size_normalized_inverted = 1.0 - Util.normalize(target_size, MIN_SIZE, MAX_SIZE)
	
	target_rot = lerp(MIN_ROTATION, MAX_ROTATION, size_normalized_inverted)
	rotation_degrees.x = lerp(rotation_degrees.x, target_rot, delta * ZOOM_SPEED)
	
	if TARGET:
		var mouse_position = Util.get_mouse_position_normalized(get_viewport()) - Vector2(0.5, 0.5)
		var dir := Vector3.ZERO
		if abs(mouse_position.x) > 0.5 - EDGE_THRESHOLD:
			dir.x = (abs(mouse_position.x) - EDGE_THRESHOLD) * sign(mouse_position.x) * EDGE_MOVE_SPEED.x
		if abs(mouse_position.y) > 0.5 - EDGE_THRESHOLD:
			dir.z = (abs(-mouse_position.y) - EDGE_THRESHOLD) * -sign(mouse_position.y) * EDGE_MOVE_SPEED.y
			
		var world_dir = dir.clamp(Vector3(-2, 0, -2), Vector3(2, 0, 2)).rotated(Vector3.UP, -rotation.y)
		var world_speed = world_dir.length()
		edge_move_offset += world_dir.normalized() * world_speed
		edge_move_offset = Util.clamp_to_sphere(edge_move_offset, 3)
		
		if Input.is_action_just_pressed("recenter_camera"):
			edge_move_offset = Vector3.ZERO
		
		zoom_position_offset = lerp(MIN_ZOOM_POSSITON_OFFSET, MAX_ZOOM_POSITION_OFFSET, size_normalized_inverted)
		
		global_position.x = lerp(global_position.x, 
								 TARGET.global_position.x - DIAGONAL_OFFSET - zoom_position_offset + edge_move_offset.x, 
								 FOLLOW_SPEED * delta)
		global_position.z = lerp(global_position.z, 
								 TARGET.global_position.z + DIAGONAL_OFFSET + zoom_position_offset - edge_move_offset.z, 
								FOLLOW_SPEED * delta)
		global_position.y = lerp(global_position.y,
								 clamp(global_position.y - zoom_position_offset * .2, 12.0, 15.0),
								FOLLOW_SPEED * delta)
