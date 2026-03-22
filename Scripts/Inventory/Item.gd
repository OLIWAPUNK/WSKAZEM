class_name Item
extends RigidBody3D

const CAN_BE_GRABBED_SCENE = preload("res://Scenes/GameWorld/Traits/CanBeGrabbed.tscn")

@export var identifier: String
@export var item_name: String

@export_group("Mesh Settings")
@export var mesh: Mesh
@export var mesh_y_offset: float = 0.0
@export var mesh_scale: Vector3 = Vector3.ONE

@onready var area: Area3D = $Area3D

func _ready():
	assert(identifier != "", "Identifier missing for item: " + name)
	if item_name == "":
		item_name = identifier
		assert(mesh != null, "Mesh missing for item: " + item_name)

	if area.get_child_count() == 0:
		var mesh_instance = MeshInstance3D.new()
		area.add_child(mesh_instance)
		mesh_instance.mesh = mesh
		mesh_instance.scale = mesh_scale
		mesh_instance.global_transform.origin.y += mesh_y_offset

		var collision_shape = CollisionShape3D.new()
		var convex_shape = ConvexPolygonShape3D.new()
		convex_shape.points = mesh_instance.mesh.get_faces()
		collision_shape.shape = convex_shape
		area.add_child(collision_shape)
		area.add_child(CAN_BE_GRABBED_SCENE.instantiate())
