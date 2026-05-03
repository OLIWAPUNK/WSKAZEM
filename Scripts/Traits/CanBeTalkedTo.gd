@icon("res://assets/Textures/EditorIcons/Talkable.svg")
class_name CanBeTalkedTo
extends CanBeClicked


signal change_puzzle_state(index: int)

@export var standing_point: Node3D
@export var npc_interpretation: Interpretation

var _talking_in_progress: bool = false:
	set(value):
		_talking_in_progress = value
		Global.ui_manager.gesture_menu_manager.toggle_play_button(not value)


func _init() -> void:
	overlay_outline_material = preload("res://assets/Materials/NPCOutline.tres")

func _ready() -> void:
	super._ready()
	assert(standing_point, "No standing point in %s" % self)

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
				print("[TALKIN] ", get_parent(), " endorses with: ", npc_interpretation.endorsement)
	
			_talking_in_progress = true

			var anim: AnimationPlayer = parent.get_node("BaseCharacter/AnimationPlayer")
			var tree: AnimationTree = parent.get_node("BaseCharacter/AnimationTree")

			for gesture_data in npc_interpretation.endorsement.answer:
				if gesture_data.is_npc:
					if Global.PRINT_TALK:
						print("[TALKIN] ", get_parent(), " \"emotes\" with: ", gesture_data.name)
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
		print("[TALKIN] ", get_parent(), " received from Player: [ ", mes, " ] ")

	var reaction := npc_interpretation.interpret(message)

	if reaction:

		if Global.PRINT_TALK:
			print("[TALKIN] ", get_parent(), " responds with: ", reaction)
				
		
		var anim: AnimationPlayer = parent.get_node("BaseCharacter/AnimationPlayer")
		var tree: AnimationTree = parent.get_node("BaseCharacter/AnimationTree")
		var emote_plane: MeshInstance3D = parent.get_node("BaseCharacter/EmotePlane")	

		for gesture_data in reaction.answer:
			if gesture_data.is_npc == 1: # EMOTE
				emote_plane.get_active_material(0).albedo_texture = gesture_data.display_normal

				# TODO: Fix this later, it looks really bad
				var camera = Global.camera_zone_manager.current_zone.camera_node
				var to_camera = (camera.global_transform.origin - emote_plane.global_transform.origin).normalized()
				target_rotation = atan2(to_camera.x, to_camera.z)
				emote_plane.rotation.y = target_rotation
				emote_plane.rotation.z = atan2(to_camera.x, to_camera.y)

				emote_plane.visible = true
				await get_tree().create_timer(1.0).timeout
				emote_plane.visible = false
			else:
				await play_gesture(anim, tree, gesture_data)
				
		for new_gesture in reaction.learned_gestures_from_reaction:
			Global.ui_manager.gesture_menu_manager.add_gesture(new_gesture)

	_talking_in_progress = false

	if npc_interpretation.next_puzzle_state >= 0:
		change_puzzle_state.emit(npc_interpretation.next_puzzle_state)


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
