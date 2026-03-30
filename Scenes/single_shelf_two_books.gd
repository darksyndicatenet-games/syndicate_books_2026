extends Node3D

var books_in_shelf := {}
@onready var misson_manager: Node = $"../../../../../../MissonManager"
@onready var cutscene: Area3D = $"../../../../../../Scare_1/Cutscene"
@onready var spook_1: CharacterBody3D = $"../../../../../../Scare_1/Spook_1"


func _ready() -> void:
	#spook_1.visible = false
	pass

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "TheAnimalFarm" or body.name == "TheSongOfAchilles":
		print(body.name, "entered area")
		books_in_shelf[body.name] = true
	
	if books_in_shelf.size() == 2:
		print("both books are in shelf")
		misson_manager.set_message("Check library for any people studying or looking for books")
		cutscene.monitoring = true
		#spook_1.visible = true


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.name == "TheAnimalFarm" or body.name == "TheSongOfAchilles":
		print(body.name, "exited area")
		books_in_shelf.erase(body.name)
