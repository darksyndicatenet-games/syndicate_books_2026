extends Node3D

var book1_in_area = false
var book2_in_area = false
@onready var misson_manager: Node = $"../../../../../MissonManager"

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "AnimalFarm":
		print(body.name, "entered area")
		Global.animal_farm_entered = true


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.name == "AnimalFarm":
		print(body.name, "exited area")
		Global.animal_farm_entered = false
