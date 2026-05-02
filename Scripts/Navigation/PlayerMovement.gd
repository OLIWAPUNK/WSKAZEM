extends Node

@onready var player: CharacterBody3D = $"../PlayerBody"
@onready var animation_tree: AnimationTree = player.get_node("BaseCharacter/AnimationTree")
@onready var navigation_agent: NavigationAgent3D = %PlayerNode/NavigationManager.navigation_agent
@onready var pointer_manager: PointerManager = %PointerManager

@export var ROTATION_SPEED := 10.0
@export var MOVEMENT_SPEED: float = 12.0
@export var GRAVITY_MULTIPLIER := 3.5

@onready var target_rotation: Vector3 = player.rotation_degrees
@onready var gravity: float = (ProjectSettings.get_setting("physics/3d/default_gravity") 
		* GRAVITY_MULTIPLIER)

func _ready() -> void:
	assert(player, "Player node not found")
	assert(pointer_manager, "Pointer manager not found")

	Global.player = player

	var player_position = Saves.get_data_or_null("player.position")
	if player_position != null:
		player_position = player_position as Dictionary
		player.global_position = Vector3(player_position["x"], player_position["y"], player_position["z"])


func _physics_process(delta):
	
	Global.debug.add_debug_property("Player Velocity", snapped(player.velocity.length(), 0.01), 1)
	Global.debug.add_debug_property("Player Position", player.global_position, 1)
	Global.debug.add_debug_property("Player Rotation Degrees", player.global_rotation_degrees.y, 1)
	Global.debug.add_debug_property("Player Rotation Vector", player.global_rotation.y, 1)

	if (player.velocity.length_squared() > 0.1):
		var target_angle = atan2(player.velocity.x, player.velocity.z)
		target_rotation.y = lerp_angle(player.rotation.y, target_angle, ROTATION_SPEED * delta)

		animation_tree["parameters/Transition/transition_request"] = "walk"
	else:
		animation_tree["parameters/Transition/transition_request"] = "idle"
	player.rotation = target_rotation

	if Global.map_manager.current_scene == null:
		return
	if NavigationServer3D.map_get_iteration_id(navigation_agent.get_navigation_map()) == 0:
		return

	if not player.is_on_floor():
		player.velocity.y -= gravity * delta
	
	if not navigation_agent.is_navigation_finished():
		var next_pos = navigation_agent.get_next_path_position()
		player.velocity = player.global_position.direction_to(next_pos) * MOVEMENT_SPEED
	
	player.move_and_slide()
	

func on_save():
	Saves.set_data("player.position", {
		"x": player.position.x,
		"y": player.position.y,
		"z": player.position.z,
	})
