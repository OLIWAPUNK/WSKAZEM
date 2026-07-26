@icon("res://assets/Textures/EditorIcons/SyntaxTest.svg")
class_name SyntaxTest
extends Resource

@export_group("Subtests")
@export var subtests: Array[SyntaxTest]

@export_group("Gesture composition")
@export var required_gestures: Array[GestureData]
@export var allowed_any: bool = true
@export var allowed_gestures: Array[GestureData]

## Wyłączność końcówek
## [param cap_exclusion] ustawiona na [code]true[/code] nie akceptuje wiadomości dłuższej niż końcówki.[br]
## Ustawienie [code]false[/code] ignoruje długość końcówek
@export var cap_exclusion: bool = false

@export_subgroup("Beginning")
@export var beginning_cap: SyntaxCap

@export_subgroup("End")
@export var end_cap: SyntaxCap

@export_subgroup("Key")
@export var key_gesture: GestureData
@export var cap_before_key: bool = false
@export var key_cap: SyntaxCap
@export var key_every_required: bool = false


## Wyłącznie dla wygody, opis nie ma znaczenia w kodzie
@export_group("")
@export_multiline var test_description: String


func _ready() -> void:
	assert(not key_cap or key_gesture, "No gesture for key cap in %s" % self)


func _on_success(test_depth: int) -> bool:

	_debug_info("[SYNTAX] %sTest %s passed" % ["\t".repeat(test_depth), self])
	return true


func run_syntax_test(message: Array[GestureData], started_tests: Array[SyntaxTest] = [], test_depth: int = 0) -> bool:

	_debug_info("[SYNTAX] %sRunning Syntax Test %s" % ["\t".repeat(test_depth), self])
	started_tests.append(self)

	if cap_exclusion:
		var caps_length_combined = 0
		if beginning_cap:
			caps_length_combined += beginning_cap.length
		if end_cap:
			caps_length_combined += end_cap.length
		if caps_length_combined != message.size():
			return _fail_test("[SYNTAX] %sTest %s failed: Cap exclusion detected additional gestures" % ["\t".repeat(test_depth), self])

	var message_start := 0
	if beginning_cap:
		message_start += beginning_cap.length

	var message_end = message.size()
	if end_cap:
		message_end -= end_cap.length

	if message_start > message_end:
		return _fail_test("[SYNTAX] %sTest %s failed: Message too short" % ["\t".repeat(test_depth), self])

	for test in subtests:
		if test in started_tests:
			continue
		if not test.run_syntax_test(message, started_tests):
			return _fail_test("[SYNTAX] %sTest %s failed: Subtest %s failed" % ["\t".repeat(test_depth), self, test])

	if not allowed_any and allowed_gestures.size() > 0:
		for index in range(message_start, message_end):
			if message[index] not in allowed_gestures:
				return _fail_test("[SYNTAX] %sTest %s failed: Gesture %s not allowed" % ["\t".repeat(test_depth), self, message[index].name])

	for gesture in required_gestures:
		if gesture not in message:
			return _fail_test("[SYNTAX] %sTest %s failed: No %s in message" % ["\t".repeat(test_depth), self, gesture.name])

	if beginning_cap:
		if not beginning_cap.check_cap(message.slice(0, message_start)):
			return _fail_test("[SYNTAX] %sTest %s failed: Beggining cap failed" % ["\t".repeat(test_depth), self])

	if end_cap:
		if not end_cap.check_cap(message.slice(message_end, message.size())):
			return _fail_test("[SYNTAX] %sTest %s failed: End cap failed" % ["\t".repeat(test_depth), self])

	if not key_cap:
		return _on_success(test_depth)

	var cap_result: bool = false
	if key_every_required:
		cap_result = true

	for index in message.size():
		if message[index] != key_gesture:
			continue

		var new_result: bool

		if cap_before_key:
			if index < key_cap.length:
				return _fail_test("[SYNTAX] %sTest %s failed: Message too short for key" % ["\t".repeat(test_depth), self])
			new_result = key_cap.check_cap(message.slice(index - key_cap.length, index))
		else:
			if message.size() - index - 1 < key_cap.length:
				return _fail_test("[SYNTAX] %sTest %s failed: Message too short for key" % ["\t".repeat(test_depth), self])
			new_result = key_cap.check_cap(message.slice(index + 1, index + key_cap.length + 1))

		if key_every_required:
			cap_result = cap_result and new_result
		else:
			cap_result = cap_result or new_result

	if cap_result:
		return _on_success(test_depth)
	else:
		return _fail_test("[SYNTAX] %sTest %s failed: Key cap failed" % ["\t".repeat(test_depth), self])


func _fail_test(feedback: String) -> bool:

	_debug_info(feedback)
	return false


func _debug_info(feedback: String) -> void:

	if Global.PRINT_TEST_STEPS:
		print(feedback)