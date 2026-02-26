@icon("res://Textures/EditorIcons/SyntaxCap.svg")
class_name SyntaxCap
extends Resource

enum capMode {ALLOWED, REQUIRED, STRICT}
@export var length: int = 0
@export var gestures: Array[GestureData]
@export var mode: capMode = capMode.ALLOWED

# ALERT: co z typami gestów?


func _ready() -> void:
    
    match mode:

        capMode.REQUIRED:
            if length >= gestures.size():
                return
            
            push_warning("Length for REQUIRED should be >= size of gestures in %s (seting length = size)" % self)
            length = gestures.size()

        capMode.STRICT:
            if length == gestures.size():
                return

            push_warning("Length for STRICT should be = size of gestures in %s (seting length = size)" % self)
            length = gestures.size()
            

func _check_allowed(sub_message: Array[GestureData]) -> bool:
    
    for gesture in sub_message:
        if gesture not in gestures:
            return false
    
    return true


func _check_required(sub_message: Array[GestureData]) -> bool:
    
    for gesture in gestures:
        if gesture not in sub_message:
            return false
    
    return true


func _check_strict(sub_message: Array[GestureData]) -> bool:

    for index in sub_message.size():
        if gestures[index] != sub_message[index]:
            return false

    return true


func check_cap(sub_message: Array[GestureData]) -> bool:
    assert(sub_message.size() == length, "Can't pass sub_message, wrong length")

    if Global.PRINT_TEST_STEPS:
        print("\tDEBUG ", sub_message)

    match mode:

        capMode.ALLOWED:
            return _check_allowed(sub_message)

        capMode.REQUIRED:
            return _check_required(sub_message)

        capMode.STRICT:
            return _check_strict(sub_message)

        _:
            push_warning("No mode set in %s cap" % self)
            return false
