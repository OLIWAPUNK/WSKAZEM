@tool
extends GraphNode

const entry_template = preload("res://addons/InterpretationMaker/Nodes/GestureEntryTemplate.tscn")
var entries: Array[HBoxContainer]


func _ready() -> void:
	$AddButton.pressed.connect(add_entry)


func add_entry() -> void:
	var new_entry: HBoxContainer = entry_template.instantiate()
	new_entry.get_node("Index").text = str(entries.size())
	var delete_index = entries.size()
	new_entry.get_node("RemoveButton").pressed.connect(func (): delete_entry(delete_index))
	var option_button: OptionButton = new_entry.get_node("OptionButton")
	for gesture_index in Global.all_gestures.size():
		option_button.add_item(Global.all_gestures[gesture_index].name, gesture_index)
	
	if entries.size() == 0:
		$ArrayStart.add_sibling(new_entry)
	else:
		entries.back().add_sibling(new_entry)
	entries.append(new_entry)
	
	
func delete_entry(index: int) -> void:
	entries[index].queue_free()
	entries.pop_at(index)
	refresh_array()
	
	
func refresh_array() -> void:
	for entry_index in entries.size():	
		entries[entry_index].get_node("Index").text = str(entry_index)
		var method: Callable = entries[entry_index].get_node("RemoveButton").pressed.get_connections()[0]["callable"]
		entries[entry_index].get_node("RemoveButton").pressed.disconnect(method)
		entries[entry_index].get_node("RemoveButton").pressed.connect(func (): delete_entry(entry_index))
	
	
	
