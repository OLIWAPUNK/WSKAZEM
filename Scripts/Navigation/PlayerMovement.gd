extends Node

@onready var player: CharacterBody3D = $"../PlayerBody"
@onready var pointer_manager: PointerManager = %PointerManager

@export var ROTATION_SPEED := 10.0
@export var MOVEMENT_SPEED: float = 12.0
@export var GRAVITY_MULTIPLIER := 3.5

@onready var target_rotation: Vector3 = player.rotation_degrees
@onready var gravity: float = (ProjectSettings.get_setting("physics/3d/default_gravity") 
		* GRAVITY_MULTIPLIER)

var direction: Vector3 = Vector3.ZERO
var last_frame_held = false

func _ready() -> void:
	assert(player, "Player node not found")
	assert(pointer_manager, "Pointer manager not found")


func _physics_process(delta):
	
	Global.debug.add_debug_property("Velocity", snapped(player.velocity.length(), 0.01), 1)

	if not player.is_on_floor():
		player.velocity.y -= gravity * delta

	if pointer_manager.hold_mouse_movements:
		if not last_frame_held:
			last_frame_held = true
		var mouse_pos = get_viewport().get_mouse_position()
		var origin = get_viewport().get_visible_rect().size / 2
		var delta_pos = mouse_pos - origin
		var input_vector = Vector2(delta_pos.x, delta_pos.y).normalized()
		target_rotation.y = atan2(input_vector.x, input_vector.y) + get_viewport().get_camera_3d().rotation.y
		direction = Vector3(sin(target_rotation.y), 0, cos(target_rotation.y))
		player.velocity.x = direction.x * MOVEMENT_SPEED
		player.velocity.z = direction.z * MOVEMENT_SPEED

	if not pointer_manager.hold_mouse_movements and last_frame_held:
		last_frame_held = false
		player.velocity.x = 0
		player.velocity.z = 0
	
	if not %PlayerNode/NavigationManager.navigation_agent.is_navigation_finished():
		if pointer_manager.hold_mouse_movements:
			%PlayerNode/NavigationManager.end_navigation()
		else:
			var targetPos = %PlayerNode/NavigationManager.navigation_agent.get_next_path_position()
			direction = player.global_position.direction_to(targetPos)
			player.velocity = direction * MOVEMENT_SPEED

	if (player.velocity.length_squared() > 0.1):
		var target_angle = atan2(direction.x, direction.z)
		target_rotation.y = lerp_angle(player.rotation.y, target_angle, ROTATION_SPEED * delta)
	player.rotation = target_rotation

	player.move_and_slide()
