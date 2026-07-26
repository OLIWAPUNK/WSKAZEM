@icon("res://assets/Textures/EditorIcons/Interpretation.svg")
class_name Interpretation
extends Node


@export_category("Endorsement Message")
@export var endorsement: Reaction

var endorsement_made: bool = false

@export_category("Thought Processing")
@export var default_thought: int = 0
@export var thoughts: Array[Thought] = []

@export var reset_reaction: Reaction # WARNING "hola hola, zacznijmy od początku" type reakcja

var current_thought: int = 0

var next_puzzle_state: int = -1

## Wyłącznie dla wygody, opis nie ma znaczenia w kodzie
@export_multiline var interpretation_description: String


func _ready() -> void:
	assert(thoughts.size() > 0, "No thoughts in %s" % self)
	assert(0 <= default_thought and default_thought < thoughts.size(), "default_thought outside of thouhgt range in %s" % self)

	# WARNING Ustawia na default, może nie być przydatne przy zapisywaniu postępu!!!
	current_thought = default_thought


func interpret(message: Array[GestureData]) -> Reaction:
	
	var behaviour: ConditionalBehaviour = thoughts[current_thought].check_behaviour(message)

	if not behaviour:
		return thoughts[current_thought].dumb_reaction

	var _prev = current_thought
	
	if message.reduce(func (acum: bool, gesture: GestureData): 
		return (gesture.type == GestureData.gestureCategory.ITEM) or acum, 
	false):
		print("HAS ITEM!!!!")
		# TODO remove item and reset message_item_index in gesturemenumanager

	if behaviour.next_puzzle_state >= 0:
		current_thought = default_thought
		next_puzzle_state = behaviour.next_puzzle_state
	elif behaviour.next_thought >= 0:
		current_thought = behaviour.next_thought

	Global.print_talk("[INTERP] Change thought %s -> %s" % [_prev, current_thought])
	if next_puzzle_state != -1:
		Global.print_talk("[INTERP] Change PUZZLE STATE -> %s" % next_puzzle_state)

	return behaviour.reaction
