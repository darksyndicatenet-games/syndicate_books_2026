extends Node3D

var book1_in_area = false
var book2_in_area = false
@onready var misson_manager: Node = $"../../../../MissonManager"

	#if body.is_in_group("books"):
		#var book_name = body.name
		#
		#if book_name == "ThePowerofYourSubconsciousMind" or book_name == "TheRoutledgeHandbookofPhilosophyofEmpathy":
			#print(book_name + " success")


func _on_area_3d_body_entered(body: Node3D) -> void:
	var book_name = body.name
	
	if book_name == "AnimalFarm":
		book1_in_area = true
		
	if book_name == "TheRoutledgeHandbookofPhilosophyofEmpathy":
		book2_in_area = true
	
	if book1_in_area and book2_in_area:
		print("success")
		misson_manager.set_message("Check library for any people studying or looking for books") 


func _on_area_3d_body_exited(body: Node3D) -> void:
	var book_name = body.name
	
	if book_name == "AnimalFarm":
		book1_in_area = false
		
	if book_name == "TheRoutledgeHandbookofPhilosophyofEmpathy":
		book2_in_area = false
