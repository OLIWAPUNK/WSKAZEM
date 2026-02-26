
class_name PuzzleZoneState
extends Node

@export var learnable_gestures: Array[GestureData]
@export var state_interpretations: Dictionary[String, Interpretation]

var parent: PuzzleZone
var receiver: GateReceiver


func _ready() -> void:
	
	var parent_node = get_parent()
	assert(parent_node is PuzzleZone, "Parent node is not a PuzzleZone in %s" % self)
	parent = parent_node

	var child_receiver = get_node("StateReceiver")
	assert(child_receiver, "No StateReceiver as child of %s" % self)
	assert(child_receiver is GateReceiver, "Node named StateReceiver is not GateReceiver in %s" % self)
	receiver = child_receiver

	child_receiver.receive.connect(change_to_me)


func change_to_me(_gate_name: String) -> void:
	print(_gate_name, " called me ", self)
	parent.change_state(self)


func brain_controll() -> void:

	for npc_name in state_interpretations:
		var npc_to_change: CanBeTalkedTo = parent.npcs.get(npc_name)
		if not npc_to_change:
			push_warning("No npc named %s in PuzzleZone %s" % [npc_name, parent])
			continue
		npc_to_change.npc_interpretation = state_interpretations[npc_name]