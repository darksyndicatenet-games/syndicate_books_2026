extends Control
@onready var opening_scene: VideoStreamPlayer = $OpeningScene
@onready var instructions: VideoStreamPlayer = $Instructions


func _ready() -> void:
	instructions.visible = false

func _on_quitbtn_pressed() -> void:
	get_tree().quit()


func _on_optionbtn_pressed() -> void:
	instructions.visible = true
	#opening_scene.visible = false
	instructions.play()
	instructions.loop = true
	pass # Replace with function body.


func _on_startbtn_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/library_main.tscn")
	pass


func _on_quitbtn_2_pressed() -> void:
	instructions.visible = false
	#opening_scene.visible = true
	pass # Replace with function body.
