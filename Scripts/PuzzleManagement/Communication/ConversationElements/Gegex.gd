@tool
class_name Gegex
extends Node


@export var gesture_dictionary: Dictionary[GestureData, String]


func construct_string(message: Array[GestureData]) -> String:

    var message_string: String = ""

    for gesture in message:
        var character: String = gesture_dictionary.get(gesture)
        assert(character != null, "No gesture %s in dictionary" % gesture)
        assert(character.length() == 1, "Gesture in dictionary set to string not character (len != 1)")
        message_string += character

    return message_string


func test_string(test: String, message: String) -> bool:

    var regex: RegEx = RegEx.create_from_string(test)
    var result: RegExMatch = regex.search(message)

    return result.get_string() == message


func test_message(test: String, message: Array[GestureData]) -> bool:
    return test_string(test, construct_string(message))
