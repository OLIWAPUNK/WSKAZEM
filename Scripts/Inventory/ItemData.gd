class_name ItemData
extends Resource

@export var identifier: String
@export var item_name: String
@export var scene_path: String

@export_group("Mesh Settings")
@export var mesh: Mesh
@export var mesh_y_offset: float = 0.0
@export var mesh_scale: Vector3 = Vector3.ONE