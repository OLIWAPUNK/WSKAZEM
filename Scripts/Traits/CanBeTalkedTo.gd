@icon("res://assets/Textures/EditorIcons/Talkable.svg")
class_name CanBeTalkedTo
extends CanBeClicked


signal change_puzzle_state(index: int)

@export var npc_interpretation: Interpretation

@onready var body: CharacterBody3D = parent.get_parent() as CharacterBody3D
@onready var character = parent.get_node("Character")
@onready var animation_player: AnimationPlayer = character.get_node("AnimationPlayer")
@onready var animation_tree: AnimationTree = character.get_node("AnimationTree")
@onready var focus_view = parent.get_node("FocusView")

var _talking_in_progress: bool = false:
	set(value):
		_talking_in_progress = value
		Global.ui_manager.gesture_menu_manager.toggle_play_button(not value)
var rng = RandomNumberGenerator.new()
var was_not_moving_last_frame: bool = false
var target_rotation: float = 0.0
var navigation_agent: NavigationAgent3D


func _init() -> void:
	overlay_outline_material = preload("res://assets/Materials/NPCOutline.tres")

func _ready() -> void:
	super._ready()
	assert(standing_point, "No standing point in %s" % self)
	assert(focus_view is Camera3D, "No Camera3D as FocusView")
	assert(body, "No CharacterBody3D in %s" % parent.get_path())
	body.input_ray_pickable = false

	var saved_data = Saves.get_data_or_null("npcs.%s" % body.get_path())
	if saved_data != null:
		if saved_data.has("position"):
			body.global_transform.origin = SerDeUtil.deserialize_vector3(saved_data.position)
		if saved_data.has("navigation_target"):
			move_to(SerDeUtil.deserialize_vector3(saved_data.navigation_target))

	if not is_in_group("GameEvents"):
		add_to_group("GameEvents")

func on_save() -> void:
	var data = {
		"position": SerDeUtil.serialize_vector3(body.global_transform.origin),
	}
	if navigation_agent and not navigation_agent.is_navigation_finished():
		data["navigation_target"] = SerDeUtil.serialize_vector3(navigation_agent.target_position)
	Saves.set_data("npcs.%s" % body.get_path(), data)

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

			for gesture_data in npc_interpretation.endorsement.answer:
				if gesture_data.type == GestureData.gestureCategory.ITEM:
					if Global.PRINT_TALK:
						print("[TALKIN] ", get_parent(), " \"emotes\" with: ", gesture_data.name)
					continue
				await play_gesture(animation_player, animation_tree, gesture_data)
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
		if gesture_data.type == GestureData.gestureCategory.ITEM:
			print("ITEM: ", gesture_data)
		else:
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
				
		
		var emote: Sprite3D = character.get_node("Emote")	

		for gesture_data in reaction.answer:
			if gesture_data.type == GestureData.gestureCategory.EMOTE: # EMOTE
				emote.texture = gesture_data.display_normal

				emote.visible = true
				await get_tree().create_timer(1.0).timeout
				emote.visible = false
			else:
				await play_gesture(animation_player, animation_tree, gesture_data)
				
		for new_gesture in reaction.learned_gestures_from_reaction:
			Global.ui_manager.gesture_menu_manager.add_gesture(new_gesture)

	_talking_in_progress = false

	if npc_interpretation.next_puzzle_state >= 0:
		change_puzzle_state.emit(npc_interpretation.next_puzzle_state)


func play_gesture(anim_player: AnimationPlayer, tree: AnimationTree, gesture_data: GestureData) -> Signal:
	tree.get_tree_root().get_node("animation").animation = gesture_data.animation_name
	tree["parameters/OneShot/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
	var anim_length = anim_player.get_animation(gesture_data.animation_name).length
	return get_tree().create_timer(anim_length).timeout

func move_to(position: Vector3) -> void:
	navigation_agent = body.get_node("NavigationAgent3D")
	assert(navigation_agent is NavigationAgent3D, "No NavigationAgent3D in %s" % body.get_path())
	navigation_agent.target_position = position
	navigation_agent.navigation_finished.connect(_on_navigation_finished)
	is_disabled = true

func _on_navigation_finished() -> void:
	is_disabled = false
	body.velocity = Vector3.ZERO

func _physics_process(delta: float) -> void:
	if _talking_in_progress and character.rotation.y != target_rotation:
		character.rotation.y = lerp_angle(character.rotation.y, target_rotation, Global.ROTATION_SPEED * delta / 2)

	if not navigation_agent:
		return

	if body.velocity.length_squared() > 0.1:
		var target_angle = atan2(body.velocity.x, body.velocity.z)
		target_rotation = lerp_angle(character.rotation.y, target_angle, Global.ROTATION_SPEED * delta)

		animation_tree["parameters/Transition/transition_request"] = "walk"
		was_not_moving_last_frame = false
	elif not was_not_moving_last_frame:
		animation_tree.get_tree_root().get_node("idle").animation = "idle" + str(rng.randi_range(1, 4))
		animation_tree["parameters/Transition/transition_request"] = "idle"
		was_not_moving_last_frame = body.velocity.length_squared() <= 0.1
	character.rotation.y = target_rotation

	if Global.map_manager.current_scene == null or NavigationServer3D.map_get_iteration_id(navigation_agent.get_navigation_map()) == 0:
		return

	if not body.is_on_floor():
		body.velocity.y -= Global.gravity * delta

	if not navigation_agent.is_navigation_finished():
		var next_pos = navigation_agent.get_next_path_position()
		body.velocity = body.global_position.direction_to(next_pos) * Global.MOVEMENT_SPEED

	body.move_and_slide()
