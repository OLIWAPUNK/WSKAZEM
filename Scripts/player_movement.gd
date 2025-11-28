extends Node

@onready var player_node: CharacterBody3D = $"../PlayerBody"

@export_group("Movement")
@export var MOVEMENT_SPEED: float = 1000
@export var GRAVITY: float = -300


func _ready() -> void:
	assert(player_node, "Nie znaleziono CharacterBody3D")


func get_input(delta: float) -> void:
	
	var input_direction_2d := Input.get_vector("up", "down", "right", "left")
	var input_direction_3d := Vector3(input_direction_2d.x, 0, input_direction_2d.y)
	
	player_node.velocity = input_direction_3d * MOVEMENT_SPEED * delta


func apply_gravity(delta: float) -> void:
	
	player_node.velocity.y = GRAVITY * delta
	

func _physics_process(delta: float) -> void:
	
	get_input(delta)
	apply_gravity(delta)
	player_node.move_and_slide()
