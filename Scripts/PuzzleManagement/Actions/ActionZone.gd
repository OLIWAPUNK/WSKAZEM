class_name ActionZone
extends Area3D


@export var animation_package: AnimationPackage
@export var action_method: String

enum actionFire {ONCE, EACH}
var is_fired: bool = false
@export var action_fire: actionFire = actionFire.ONCE

@export_subgroup("Progress Tracker")
var locked: bool = false
@export var activator_entry: String
@export var progress_entry: String


func _ready() -> void:
	assert(animation_package, "No AnimationPackage set in %s" % self)
	assert(animation_package.has_method(action_method), "No action method called \"%s\" in AnimationPackage for %s" % [action_method, self])
	if activator_entry != "":
		assert(Global.progress_tracker.has_entry(activator_entry), "Activator entry \"%s\" does not exists for %s" % [activator_entry, self])
	if progress_entry != "":
		assert(Global.progress_tracker.has_entry(progress_entry), "Progress entry \"%s\" does not exists for %s" % [progress_entry, self])

	body_shape_entered.connect(_on_body_shape_entered)
	collision_mask = 2

	# TODO Wczytanie czy był fired z save'a

	if activator_entry != "":
		if Global.progress_tracker.check_status(activator_entry):
			return
		locked = true
		Global.progress_tracker.updated_progress.connect(unlock_zone)



func unlock_zone(entry: String):
	if entry == activator_entry:
		locked = false


func _on_body_shape_entered(_body_rid: RID, body: Node3D, _body_shape_index: int, _local_shape_index: int) -> void:
	if body is not CharacterBody3D:
		return
	if locked:
		return
	if is_fired and action_fire == actionFire.ONCE:
		return

	await animation_package._call_by_name(action_method)
	if not is_fired and progress_entry != "":
		Global.progress_tracker.update(progress_entry, self)

	is_fired = true
	
