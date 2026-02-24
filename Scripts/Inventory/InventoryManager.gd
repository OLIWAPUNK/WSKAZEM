class_name InventoryManager
extends Node

@onready var item_mesh: MeshInstance3D = %ItemMesh
@onready var panel: Panel = $"../SlotContainer/Panel"

# var held_item: ItemData = null
var held_item: ItemData = preload("res://Resources/Items/RockItem.tres")

func _ready() -> void:
	panel.gui_input.connect(_on_panel_gui_input)
	panel.mouse_entered.connect(_on_panel_mouse_entered)

	if held_item:
		_set_mesh(held_item.mesh)
	else:
		_clear_mesh()

func _on_panel_gui_input(event: InputEvent) -> void:
	print_debug("dgmervnewkvbgwlk")
	if event is InputEventMouse and event.is_action_just_pressed("mouse_interact"):
		drop()

		get_viewport().set_input_as_handled()

func _on_panel_mouse_entered() -> void:
	print_debug("dgmervnewkvbgwlk")

func _set_mesh(mesh: Mesh):
	item_mesh.mesh = mesh
	item_mesh.visible = mesh != null

func _clear_mesh():
	item_mesh.mesh = null
	item_mesh.visible = false

func grab(object: CanBeGrabbed):
	var item_object: Item = object.parent
	if held_item:
		drop()
	held_item = item_object.item_data
	_set_mesh(held_item.mesh)
	item_object.queue_free()

func drop():
	held_item = null
	_clear_mesh()
