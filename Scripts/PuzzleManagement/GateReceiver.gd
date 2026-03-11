@tool
@icon("res://Textures/EditorIcons/GateReceiver.svg")
class_name GateReceiver
extends Node

signal receive(gate_name: String)
 
@onready var parent: Node = $".."

@export_multiline var node_description: String


func _ready() -> void:
	assert(parent, "No parent")


func signal_receive(gate: Gate) -> void:
	print(self, " received from ", gate)
	receive.emit(gate.name)