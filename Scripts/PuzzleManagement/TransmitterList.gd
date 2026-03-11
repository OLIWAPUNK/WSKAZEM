@tool
class_name TransmitterList
extends Resource


@export var gate_names: Array[String]


static func index_of(list: TransmitterList, name: String) -> int:

    for index in list.gate_names.size():
        if list.gate_names[index] == name:
            return index

    return -1