extends AnimationPackage

@export var NPC_Dziewczynka: CanBeTalkedTo
@export var ATZ_Wyj_Peron: AutoTravelZone


func A01_Dziewczynka_Enter():
	NPC_Dziewczynka.move_to(Vector3(69.58, 0, -7.591))
	ATZ_Wyj_Peron.enabled = true

func test_kurwa():
	_remove_looper("test_cipka")

func test_cipka():
	print("CIPKA")
