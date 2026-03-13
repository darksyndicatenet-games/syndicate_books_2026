extends Area3D

# -----------------------------
# Nodes & Targets
# -----------------------------
@onready var label: Label = $FadeText/Label       # 3D world text
@onready var misson_manager: Node = $"../../MissonManager"  # mission text HUD

@export var player: CharacterBody3D
@export var look_target: Marker3D        # direction player should look
@export var spook_1: CharacterBody3D     # optional NPC

# -----------------------------
# Cutscene Settings
# -----------------------------
@export_multiline var message: String = "Hello"         # Thoughts / 3D text
@export_multiline var mission_text: String = ""        # Mission HUD text
@export var fade_time: float = 1.0
@export var stay_time: float = 2.0
@export var auto_play: bool = true


@export var play_scene_once: bool

# -----------------------------
# Internal
# -----------------------------
var has_played: bool = false   # ensures the cutscene only triggers once

# -----------------------------
# Ready
# -----------------------------
func _ready() -> void:
	label.text = message
	label.modulate.a = 0.0

	if auto_play and not has_played:
		play_cutscene()

# -----------------------------
# Play cutscene
# -----------------------------
func play_cutscene() -> void:
	if has_played:
		return

	has_played = true
	#monitoring = false  # only triggers once
	set_deferred("monitoring", false)
	Global.played_cutscene_1 = true

	# Show player's thoughts
	play_fade()

	# Update mission HUD
	if mission_text != "" and misson_manager:
		misson_manager.set_message(mission_text)

	# Force player to look at target
	if player and look_target:
		player.force_look_at(look_target.global_position)

# -----------------------------
# Fade animations for thoughts
# -----------------------------
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

# -----------------------------
# Update thoughts dynamically
# -----------------------------
func set_thoughts(new_text: String):
	message = new_text
	label.text = new_text

# -----------------------------
# Trigger cutscene when player enters
# -----------------------------
#func _on_body_entered(body: Node3D) -> void:

func _on_body_entered(body: Node3D) -> void:
	if play_scene_once:
		if has_played:
			return

		if body == player:
			play_cutscene()
	else:
		return

		
		
