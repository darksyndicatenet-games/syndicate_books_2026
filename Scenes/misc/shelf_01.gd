extends MeshInstance3D


#func _on_area_3d_area_entered(area: Area3D) -> void:



func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("books"):
		var book_name = body.name
		
		if book_name == "ThePowerofYourSubconsciousMind" or book_name == "TheRoutledgeHandbookofPhilosophyofEmpathy":
			print(book_name + " success")
