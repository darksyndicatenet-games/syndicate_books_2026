extends Node2D

var next_scene = preload("res://Scenes/ScreenMenu/StartScreenMenu.tscn")

func _on_video_stream_player_finished() -> void:
	get_tree().quit()
	get_tree().change_scene_to_packed(next_scene)
