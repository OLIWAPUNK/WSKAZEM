@icon("res://assets/Textures/EditorIcons/Talkable.svg")
class_name CanBeTalkedTo
extends CanBeClicked

@export var npc_interpretation: Interpretation

var _talking_in_progress: bool = false:
	set(value):
		_talking_in_progress = value
		Global.ui_manager.gesture_menu_manager.toggle_play_button(not value)


func _init() -> void:
	overlay_outline_material = preload("res://assets/Materials/NPCOutline.tres")

var target_rotation: float = 0.0

func _process(delta: float) -> void:
	parent.rotation.y = lerp_angle(parent.rotation.y, target_rotation, 5 * delta)

func start_talking() -> void:
	
	var player_pos = Global.player.global_transform.origin
	var npc_pos = parent.global_transform.origin
	var direction = (player_pos - npc_pos).normalized()
	target_rotation = atan2(direction.x, direction.z)

	if npc_interpretation:
		if npc_interpretation.endorsement and not npc_interpretation.endorsement_made:
			
			if Global.PRINT_TALK:
				print(self, " ZACZYNA OD ", npc_interpretation.endorsement)
	
			_talking_in_progress = true

			var anim: AnimationPlayer = parent.get_node("BaseCharacter/AnimationPlayer")
			var tree: AnimationTree = parent.get_node("BaseCharacter/AnimationTree")

			for gesture_data in npc_interpretation.endorsement.answer:
				if gesture_data.is_npc:
					print(gesture_data.name)
					continue
				await play_gesture(anim, tree, gesture_data)
			_talking_in_progress = false

			for new_gesture in npc_interpretation.endorsement.learned_gestures_from_reaction: 
				Global.ui_manager.gesture_menu_manager.add_gesture(new_gesture)

		npc_interpretation.endorsement_made = false


func tell(message: Array[GestureData]) -> void:
	if not npc_interpretation or _talking_in_progress:
		return

	_talking_in_progress = true

	var player_anim: AnimationPlayer = Global.player.get_node("BaseCharacter/AnimationPlayer")
	var player_tree: AnimationTree = Global.player.get_node("BaseCharacter/AnimationTree")
	for gesture_data in message:
		await play_gesture(player_anim, player_tree, gesture_data)

	var mes = " ".join(message.map(func(gesture_data: GestureData) -> String:
		return gesture_data.name
	))

	if Global.PRINT_TALK:
		print(self, " OTRZYAMLEM [ ", mes, " ]")

	var reaction := npc_interpretation.interpret(message)

	if Global.PRINT_TALK:
		print(self, " ODPOWIADAM ", reaction)

	var anim: AnimationPlayer = parent.get_node("BaseCharacter/AnimationPlayer")
	var tree: AnimationTree = parent.get_node("BaseCharacter/AnimationTree")

	if not reaction:
		return

	for gesture_data in reaction.answer:
		if gesture_data.is_npc:
			print(gesture_data.name)
			continue
		await play_gesture(anim, tree, gesture_data)
	_talking_in_progress = false

	for new_gesture in reaction.learned_gestures_from_reaction:
		Global.ui_manager.gesture_menu_manager.add_gesture(new_gesture)

	if npc_interpretation.next_transmition >= 0:
		npc_interpretation.transmitter.gate_transmit(npc_interpretation.next_transmition)


func play_gesture(animation_player: AnimationPlayer, animation_tree: AnimationTree, gesture_data: GestureData) -> Signal:
	animation_tree.get_tree_root().get_node("animation").animation = gesture_data.animation_name
	animation_tree["parameters/OneShot/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
	var anim_length = animation_player.get_animation(gesture_data.animation_name).length
	return get_tree().create_timer(anim_length).timeout

func can_focus() -> bool:
	return parent.has_node("FocusView")

func get_focus_position() -> Vector3:
	assert(can_focus(), "Object doesn't have a focus view node!")
	return parent.get_node("FocusView").global_position

func change_interpretation() -> void:
	pass
