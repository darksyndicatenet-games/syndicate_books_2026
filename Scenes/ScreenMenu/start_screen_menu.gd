extends Control


func _on_quitbtn_pressed() -> void:
	get_tree().quit()


func _on_optionbtn_pressed() -> void:
	pass # Replace with function body.


func _on_startbtn_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/library_main.tscn")
	pass
