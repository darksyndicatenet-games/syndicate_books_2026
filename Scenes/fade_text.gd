extends Area3D

@export_multiline var message: String = "Hello"
@export var fade_time: float = 1.0
@export var stay_time: float = 2.0
@export var auto_play: bool = true

@export var player: CharacterBody3D
var has_player_entered :bool = false
@onready var label: Label = $FadeText/Label

func _ready():
	
	label.text = message
	label.modulate.a = 0.0
	
	if auto_play:
		play_fade()


func play_fade() -> void:
	await fade_in()
	await get_tree().create_timer(stay_time).timeout
	await fade_out()


func fade_in() -> void:
	var tween = create_tween()
	tween.tween_property(label, "modulate:a", 1.0, fade_time)
	await tween.finished


func fade_out() -> void:
	var tween = create_tween()
	tween.tween_property(label, "modulate:a", 0.0, fade_time)
	await tween.finished

func set_message(new_text: String):
	message = new_text
	label.text = new_text

func _on_body_entered(_body: Node3D) -> void:
	if has_player_entered == false:
		play_fade()
		has_player_entered = true
