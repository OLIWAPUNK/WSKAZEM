extends Node

@onready var player: CharacterBody3D = $"../PlayerBody"
@onready var navigationAgent : NavigationAgent3D = $"../PlayerBody/NavigationAgent3D"
@onready var movement_indicator: MeshInstance3D = $"../MovementIndicator"

@export var ROTATION_SPEED := 10.0
@export var MOVEMENT_SPEED: float = 20.0
@export var GRAVITY_MULTIPLIER := 3.5
@export_range(0.0, 1.0, 0.05) var AIR_CONTROL := 0.3

@onready var target_rotation: Vector3 = player.rotation_degrees
@onready var gravity: float = (ProjectSettings.get_setting("physics/3d/default_gravity") 
		* GRAVITY_MULTIPLIER)



func _ready() -> void:
	assert(player, "Player node not found")
	assert(navigationAgent, "NavigationAgent3D not found")
	assert(movement_indicator, "MovementIndicator not found")
	
	navigationAgent.target_position = player.global_position

	navigationAgent.connect("navigation_finished", _on_navigation_agent_finished)


func _physics_process(delta):
	
	Global.debug.add_debug_property("Velocity", snapped(player.velocity.length(), 0.01), 1)

	if not player.is_on_floor():
		player.velocity.y -= gravity * delta

	if (navigationAgent.is_navigation_finished()):
		return

	var targetPos = navigationAgent.get_next_path_position()
	var direction = player.global_position.direction_to(targetPos)

	if (player.velocity.length_squared() > 0.1):
		var target_angle = atan2(direction.x, direction.z)
		target_rotation.y = lerp_angle(player.rotation.y, target_angle, ROTATION_SPEED * delta)
	player.rotation = target_rotation

	player.velocity = direction * MOVEMENT_SPEED
	player.move_and_slide()


func _on_navigation_agent_finished() -> void:

	print("Navigation Finished")
	movement_indicator.visible = false


func _unhandled_input(_event: InputEvent) -> void:

	if Input.is_action_just_pressed("go_to_point"):
		
		var camera = get_viewport().get_camera_3d()
		var mousePos = get_viewport().get_mouse_position()
		var rayLength = 100.0
		var from = camera.project_ray_origin(mousePos)
		var to = from + camera.project_ray_normal(mousePos) * rayLength
		var rayQuery = PhysicsRayQueryParameters3D.new()
		rayQuery.from = from
		rayQuery.to = to
		var space = player.get_world_3d().direct_space_state
		var intersection = space.intersect_ray(rayQuery)
		if intersection.is_empty():
			return
		navigationAgent.target_position = intersection.position
		movement_indicator.global_position = navigationAgent.target_position
		movement_indicator.visible = true
