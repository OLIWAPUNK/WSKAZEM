@icon("res://assets/Textures/EditorIcons/ProgressTracker.svg")
class_name ProgressTracker
extends Node


signal updated_progress(entry: String)

@export var progress: Dictionary[String, ProgressEntry]


func _ready() -> void:
	Global.progress_tracker = self

	var saved = Saves.get_data_or_null("progress") as Dictionary
	if saved == null:
		return
	for key in saved.keys():
		var e = saved[key]
		progress[key].state = e["state"]
		progress[key].count = e["count"]
		progress[key].updatee = (e["updatee"] as Array[NodePath]).map(func (u): return NodePath(u))

func on_save():
	var results = {}
	for key in progress.keys():
		var e = progress[key]
		results[key] = {
			"state": e.state,
			"count": e.count,
			"updatee": e.updatee
		}
	Saves.set_data("progress", results)


func update(entry: String, object: Node) -> void:

	if not progress.has(entry):
		push_error("%s calls for %s progress entry, which doesn't exist" % [object, entry])
		return

	if progress[entry].state:
		push_warning("%s updates already cleared %s progress entry" % [object, entry])
		return

	if object in progress[entry].updatee:
		push_warning("%s updates %s progress entry more than once" % [object, entry])
		return

	progress[entry].updatee.append(object.get_path())
	progress[entry].count += 1
	
	if progress[entry].required_updates <= progress[entry].count:
		progress[entry].state = true
		updated_progress.emit(entry)


func chceck_status(entry: String) -> bool:

	return progress[entry].state
