extends Node

@onready var player: CharacterBody3D = $"../PlayerBody"

@export var ROTATION_SPEED := 10.0
@export var MOVEMENT_SPEED: float = 20.0
@export var GRAVITY_MULTIPLIER := 3.5
@export_range(0.0, 1.0, 0.05) var AIR_CONTROL := 0.3

@onready var target_rotation: Vector3 = player.rotation_degrees
@onready var gravity: float = (ProjectSettings.get_setting("physics/3d/default_gravity") 
		* GRAVITY_MULTIPLIER)

var direction: Vector3 = Vector3.ZERO

func _ready() -> void:
	assert(player, "Player node not found")


func _physics_process(delta):
	
	Global.debug.add_debug_property("Velocity", snapped(player.velocity.length(), 0.01), 1)

	if not player.is_on_floor():
		#print("falling")
		player.velocity.y -= gravity * delta

	if not %PlayerNode/NavigationManager.navigation_agent.is_navigation_finished():

		var targetPos = %PlayerNode/NavigationManager.navigation_agent.get_next_path_position()
		direction = player.global_position.direction_to(targetPos)
		player.velocity = direction * MOVEMENT_SPEED

	if (player.velocity.length_squared() > 0.1):
		var target_angle = atan2(direction.x, direction.z)
		target_rotation.y = lerp_angle(player.rotation.y, target_angle, ROTATION_SPEED * delta)
	player.rotation = target_rotation

	player.move_and_slide()
