@icon("res://Textures/EditorIcons/SyntaxTest.svg")
class_name SyntaxTest
extends Resource

@export_group("Subtests")
@export var subtests: Array[SyntaxTest]

@export_group("Gesture composition")
@export var required_gestures: Array[GestureData]
@export var allowed_any: bool = true
@export var allowed_gestures: Array[GestureData]

@export_subgroup("Beginning")
@export var beginning_cap: SyntaxCap

@export_subgroup("End")
@export var end_cap: SyntaxCap

@export_subgroup("Key")
@export var key_gesture: GestureData
@export var cap_before_key: bool = false
@export var key_cap: SyntaxCap
@export var key_every_required: bool = false


func _ready() -> void:
	assert(not key_cap or key_gesture, "No gesture for key cap in %s" % self)


func _on_success(test_depth: int) -> bool:

	if Global.PRINT_TEST_STEPS:
		print("%sTest %s passed" % ["\t".repeat(test_depth), self])
	return true


func run_syntax_test(message: Array[GestureData], started_tests: Array[SyntaxTest] = [], test_depth: int = 0) -> bool:

	if Global.PRINT_TEST_STEPS:
		print("%sRunning Syntax Test %s" % ["\t".repeat(test_depth), self])
	started_tests.append(self)

	var message_start := 0
	if beginning_cap:
		message_start += beginning_cap.length

	var message_end = message.size()
	if end_cap:
		message_end -= end_cap.length

	if message_start > message_end:
		if Global.PRINT_TEST_STEPS:
			print("%sTest %s failed: Message too short" % ["\t".repeat(test_depth), self])
		return false

	for test in subtests:
		if test in started_tests:
			continue
		if not test.run_syntax_test(message, started_tests):
			if Global.PRINT_TEST_STEPS:
				print("%sTest %s failed: Subtest %s failed" % ["\t".repeat(test_depth), self, test])
			return false

	if not allowed_any:
		for index in range(message_start, message_end):
			if message[index] not in allowed_gestures:
				if Global.PRINT_TEST_STEPS:
					print("%sTest %s failed: Gesture %s not allowed" % ["\t".repeat(test_depth), self, message[index].name])
				return false

	for gesture in required_gestures:
		if gesture not in message:
			if Global.PRINT_TEST_STEPS:
				print("%sTest %s failed: No %s in message" % ["\t".repeat(test_depth), self, gesture.name])
			return false

	if beginning_cap:
		if not beginning_cap.check_cap(message.slice(0, message_start)):
			if Global.PRINT_TEST_STEPS:
				print("%sTest %s failed: Beggining cap failed" % ["\t".repeat(test_depth), self])
			return false

	if end_cap:
		if not end_cap.check_cap(message.slice(message_end, message.size())):
			if Global.PRINT_TEST_STEPS:
				print("%sTest %s failed: End cap failed" % ["\t".repeat(test_depth), self])
			return false

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
				if Global.PRINT_TEST_STEPS:
					print("%sTest %s failed: Message too short for key" % ["\t".repeat(test_depth), self])
				return false
			new_result = key_cap.check_cap(message.slice(index - key_cap.length, index))
		else:
			if message.size() - index - 1 < key_cap.length:
				if Global.PRINT_TEST_STEPS:
					print("%sTest %s failed: Message too short for key" % ["\t".repeat(test_depth), self])
				return false	
			new_result = key_cap.check_cap(message.slice(index + 1, index + key_cap.length + 1))

		if key_every_required:
			cap_result = cap_result and new_result
		else:
			cap_result = cap_result or new_result

	if cap_result:
		return _on_success(test_depth)
	else:
		if Global.PRINT_TEST_STEPS:
			print("%sTest %s failed: Key cap failed" % ["\t".repeat(test_depth), self])
		return false
		
	
