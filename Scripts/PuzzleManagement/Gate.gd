@icon("res://Textures/EditorIcons/Gate.svg")
class_name Gate
extends Node

signal _gate_cleared(cleared_gate: Gate)

@export var transmitters: Array[GateTransmitter] = []
@export var propagators: Array[Gate] = []

@export var receivers: Array[GateReceiver] = []

var subscribed_transmitters: Array[Node] = []
var states: Array[bool] = []

var is_gate_cleared: bool = false

enum gateType {ANY, EVERY}
@export var type: gateType = gateType.ANY


func _ready() -> void:

	for set_transmitter in transmitters:
		subscribe_transmitter(set_transmitter)

	for set_receiver in receivers:
		subscribe_receiver(set_receiver)
	
	if is_gate_cleared:
		push_warning("Gate %s cleared at start" % self)
	
	for set_receiving_gate in propagators:
		subscribe_transmitter(set_receiving_gate)


func subscribe_receiver(connectee: GateReceiver) -> void:
	connect("_gate_cleared", connectee.signal_receive)


func subscribe_transmitter(connectee: Node) -> void:

	if connectee is not Gate and connectee is not GateTransmitter:
		push_error("Connectee type not allowed %s" % connectee)
		return

	subscribed_transmitters.append(connectee)
	states.append(false)

	if connectee is Gate:
		connectee._gate_cleared.connect(update)


# TOOL!!!!
# func unsubscribe(connectee) -> bool:
	
# 	if connectee is GateReceiver:

# 		var index: int = receivers.find(connectee)
# 		if (index == -1):
# 			print("WARNING nie nzlaeziono") #push_error
# 			return false

# 		disconnect("_gate_cleared", connectee.signal_receive)

# 		return true

# 	if connectee is GateTransmitter:

# 		var index: int = transmitters.find(connectee)
# 		if (index == -1):
# 			print("WARNING nie znaleziono")
# 			return false

# 		states.pop_at(index)
#		subscribed.pop...
# 		assert(not check_gate_state(), "Warunek sie uaktywnil")

# 		return true

# 	print("WARNING zly typ obiektu")
# 	return false


func check_gate_state() -> bool:

	if subscribed_transmitters.size() == 0:	
		return true

	if type == gateType.ANY:

		for index in subscribed_transmitters.size():
			if states[index]:
				return true

		return false

	if type == gateType.EVERY:

		var returned_state = true
		for index in subscribed_transmitters.size():
			returned_state = returned_state and states[index]

		return returned_state

	return false


func update(connectee: Node) -> bool:

	if is_gate_cleared:
		return true

	var index: int = subscribed_transmitters.find(connectee)

	if index == -1:
		push_warning("Connectee %s not subscribed in %s" % [connectee, self])
		return false

	states[index] = true

	var new_state = check_gate_state()
	if new_state:
		_gate_cleared.emit(self)
		is_gate_cleared = true

	return new_state
