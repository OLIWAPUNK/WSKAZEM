extends AnimationPackage

@export var NPC_Dziewczynka: CanBeTalkedTo
@export var ATZ_Wyj_Peron: AutoTravelZone


func A01_Dziewczynka_Enter():
	NPC_Dziewczynka.move_to(Vector3(31.803, 0, 25.838))
	ATZ_Wyj_Peron.enabled = true
	NPC_Dziewczynka.get_parent().get_parent().position.y = -10


func B02_Sprzedawcy_KK():
	print("sprzedane kk")


func B02_Sprzedawcy_KS_S():
	print("sprzedane ks s")


func B02_Sprzedawcy_KS_K():
	print("sprzedane ks k")


func A03_Dziewczynka_Hungry():
	print("chuj")
