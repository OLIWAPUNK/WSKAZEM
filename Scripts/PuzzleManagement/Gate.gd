class_name Gate
extends Node

signal _gate_cleared(cleared_name: String)

var subscribed_transmitter: Array[GateTransceiver] = []
var states: Array[bool] = []

var is_gate_ready: bool = false
var is_gate_cleared: bool = false

enum gateType {OR, AND, NOT}
@export var type: gateType = gateType.OR


func _ready() -> void:
	is_gate_ready = true
	print("A")


func subscribe_receiver(connectee: GateTransceiver) -> bool:
	assert(not is_gate_cleared, "Receiver connection of %s too late, already cleared %s" % [connectee, self])

	if not is_gate_ready:
		return false

	connect("_gate_cleared", connectee.signal_receive)

	return true


func subscribe_transmitter(connectee: GateTransceiver, state: bool) -> bool:

	if not is_gate_ready:
		return false

	if type == gateType.NOT and subscribed_transmitter.size() >= 1:
		return false

	if connectee in subscribed_transmitter:
		return false

	subscribed_transmitter.append(connectee)
	states.append(state)

	var start_status := update(connectee, state)
	assert(not start_status, "Status of %s is starting the gate %s at the subscribe time" % [connectee, self])

	return true


func check_gate_state() -> bool:

	if subscribed_transmitter.size() == 0:	
		return true

	if type == gateType.NOT:
		return not states[0]

	var returned_state: bool

	if type == gateType.OR:

		returned_state = false
		for index in subscribed_transmitter.size():
			returned_state = returned_state or states[index]

	if type == gateType.AND:

		returned_state = true
		for index in subscribed_transmitter.size():
			returned_state = returned_state and states[index]

	return returned_state


func update(connectee: Node, state: bool) -> bool:

	if is_gate_cleared:
		return true
	assert(is_gate_ready, "Gate %s not ready" % self)

	var index: int = subscribed_transmitter.find(connectee)
	assert(index >= 0, "Connectee %s not subscribed in %s" % [connectee, self])

	states[index] = state

	var new_state = check_gate_state()
	if new_state:
		_gate_cleared.emit(name)
		is_gate_cleared = true
		is_gate_ready = false

	return new_state
