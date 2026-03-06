extends Area3D
#once only?
#press e to intercat snap cup to the machine

func _on_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		print("Player in coffee machine area")


func _on_placement_cup_placed_in_coffe_machine() -> void:
	pass # Replace with function body.
#now have rhe player press e in machinne
	print("Player pressed E to make coffee")
