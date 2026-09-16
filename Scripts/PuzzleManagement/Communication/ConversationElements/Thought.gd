@icon("res://assets/Textures/EditorIcons/Thought.svg")
class_name Thought
extends Resource

@export var behaviour_list: Array[ConditionalBehaviour]
@export var dumb_reaction: Reaction # Reakcja na nie zrozumiałe, ma nawracać na tę myśl


## Wyłącznie dla wygody, opis nie ma znaczenia w kodzie
@export_multiline var thought_description: String


func check_behaviour(message: Array[GestureData]) -> ConditionalBehaviour:

	for index in behaviour_list.size():
		var behaviour = behaviour_list[index]
		if behaviour.syntax_test.run_syntax_test(message, index):
			return behaviour

	return null
