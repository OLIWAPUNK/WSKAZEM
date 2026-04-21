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

@export_category("Progress Transmition")
@export var progress_signal: String

var next_progress_signal: String = ""

## Wyłącznie dla wygody, opis nie ma znaczenia w kodzie
@export_multiline var interpretation_description: String


func _ready() -> void:
	#assert(progress_signal, "No progress entry set in %s" % self)
	assert(thoughts.size() > 0, "No thoughts in %s" % self)
	assert(0 <= default_thought and default_thought < thoughts.size(), "default_thought outside of thouhgt range in %s" % self)

	# WARNING Ustawia na default, może nie być przydatne przy zapisywaniu postępu!!!
	current_thought = default_thought


func interpret(message: Array[GestureData]) -> Reaction:
	
	var behaviour := thoughts[current_thought].check_behaviour(message)

	if not behaviour:
		next_progress_signal = ""
		print(thoughts[current_thought].dumb_reaction)
		return thoughts[current_thought].dumb_reaction

	print("Był thought = ", current_thought)

	if behaviour.progress_entry:
		current_thought = default_thought
	elif behaviour.next_thought >= 0:
		current_thought = behaviour.next_thought

	print("Teraz thought = ", current_thought)

	next_progress_signal = behaviour.progress_entry
	return behaviour.reaction
