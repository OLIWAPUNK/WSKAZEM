class_name NavigationManager
extends Node

@onready var navigation_agent : NavigationAgent3D = $'../PlayerBody/NavigationAgent3D'
@onready var movement_indicator: MeshInstance3D = $'../MovementIndicator'



func _ready() -> void:
	assert(navigation_agent, "NavigationAgent3D not found")

	navigation_agent.connect("navigation_finished", _on_navigation_agent_finished)


func _on_navigation_agent_finished() -> void:

	#print("Navigation Finished")
	movement_indicator.visible = false
	%PlayerNode/PlayerBody.velocity = Vector3.ZERO


func navigate() -> void:

	var camera = get_viewport().get_camera_3d()
	var mousePos = get_viewport().get_mouse_position()
	var rayLength = 100.0
	var from = camera.project_ray_origin(mousePos)
	var to = from + camera.project_ray_normal(mousePos) * rayLength
	var rayQuery = PhysicsRayQueryParameters3D.new()
	rayQuery.from = from
	rayQuery.to = to
	var space = %PlayerNode/PlayerBody.get_world_3d().direct_space_state
	var intersection = space.intersect_ray(rayQuery)
	if intersection.is_empty():
		return
	navigation_agent.target_position = intersection.position
	movement_indicator.global_position = navigation_agent.target_position
	movement_indicator.visible = true


	