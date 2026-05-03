extends AnimationPackage


func dziewczynka() -> void:
	print("Dziewczynked")
	await cutscene_collection.play_cutscene("odchodzi")


func kucharka_pucha() -> void:
	print("Kucharked pucha")


func kucharka_chinskie() -> void:
	print("Kucharked chinskie")


func strongman_lewo() -> void:
	print("Pudlod lewo")
	await cutscene_collection.play_cutscene("do_lewej")


func strongman_prawo() -> void:
	print("Pudlod prwao")
	await cutscene_collection.play_cutscene("do_prawej")