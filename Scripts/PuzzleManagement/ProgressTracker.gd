@icon("res://assets/Textures/EditorIcons/ProgressTracker.svg")
class_name ProgressTracker
extends Node


signal updated_progress(entry: String)


@export var progress: Dictionary[String, ProgressEntry]


func _ready() -> void:
	Global.progress_tracker = self

	var saved = Saves.get_data_or_null("progress")
	if saved == null:
		return
	saved = saved as Dictionary
	for key in saved.keys():
		if not progress.has(key):
			continue
		var e = saved[key]
		progress[key].state = e["state"]
		progress[key].count = e["count"]
		progress[key].updatee.clear()
		progress[key].updatee.append_array(e["updatee"])

func on_save():
	var results = {}
	var keys = progress.keys()
	for key in keys:
		var e = progress[key]
		results[key] = {
			"state": e.state,
			"count": e.count,
			"updatee": e.updatee
		}
	Saves.set_data("progress", results)

	var total_non_extra_count = keys.reduce(func (accum, key): return accum + (1 if not progress[key].is_extra else 0), 0)
	if total_non_extra_count == 0:
		Saves.set_data("main_progress", 0.0)
	else:
		var completed_non_extra_count = keys.reduce(func (accum, key): return accum + (1 if not progress[key].is_extra and progress[key].state else 0), 0)
		Saves.set_data("main_progress", float(completed_non_extra_count / total_non_extra_count))

	var total_extra_count = keys.reduce(func (accum, key): return accum + (1 if progress[key].is_extra else 0), 0)
	if total_extra_count == 0:
		Saves.set_data("extra_progress", 0.0)
	else:
		var completed_extra_count = keys.reduce(func (accum, key): return accum + (1 if progress[key].is_extra and progress[key].state else 0), 0)
		Saves.set_data("extra_progress", float(completed_extra_count / total_extra_count))


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

	print("[PRGRSS] Updated ", entry, " by ", object)


func chceck_status(entry: String) -> bool:
	if not progress.get(entry):
		push_error("No \"%s\" entry" % entry)
		return false

	return progress[entry].state


func exists(entry: String) -> bool:
	return progress.get(entry) != null
