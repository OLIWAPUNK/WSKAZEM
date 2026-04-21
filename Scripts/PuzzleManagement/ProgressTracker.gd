@icon("res://assets/Textures/EditorIcons/ProgressTracker.svg")
class_name ProgressTracker
extends Node


signal updated_progress(entry: String)

@export var progress: Dictionary[String, ProgressEntry]


func _ready() -> void:
    Global.progress_tracker = self


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

    progress[entry].updatee.append(object)
    progress[entry].required -= 1
    
    if progress[entry].required <= 0:
        progress[entry].state = true
        updated_progress.emit(entry)


func chceck_status(entry: String) -> bool:

    return progress[entry].state