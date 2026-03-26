extends Node3D


signal iLoveYussie 

@onready var door_anim_player: AnimationPlayer = $Day1/Door/door/AnimationPlayer
@onready var bell_sound: AudioStreamPlayer3D = $Scare_1/Cutscene2/BellSound
@onready var look_target: Marker3D = $Scare_1/Cutscene2/Marker3D
@onready var turn_off_sounds_and_have_npc_2_enter: Area3D = $Scare_1/TurnOffSoundsAndHaveNPC2Enter
@onready var scare_2: Area3D = $Scare_1/Scare2
@onready var receptionist_label: Label3D = $Day1/FrontDeskArea3D/ReceptionistLabel
@onready var misson_manager: Node = $MissonManager

var bell_has_been_fired := false
var counter := 0
#@onready var spook_1: CharacterBody3D = $Scare_1/Spook_1
@export var spook_1: CharacterBody3D
# books already counted
var counted_books: Array[String] = []



#need to put a boolean value after discussing wiht the new npc 
#then player should look at study area for the guy that disappeared
#then that when the bg ambience and footsteps sfx should be turned on


# ONLY these books should count
var required_books := [
	"animal farm",
	"the song of achilles"
]

@onready var cutscene_2: Area3D = $Scare_1/Cutscene2

var player_in_area:= false


#proximity scary atmosphere sound
@onready var scary_object: CSGBox3D = $NavigationRegion3D/Map/Misc/Desk
@onready var player: CharacterBody3D = $Player
@onready var scary_background_audio: AudioStreamPlayer3D = $NavigationRegion3D/Map/Misc/Desk/scaryBackgroundAudio

# Max distance at which sound is still audible
var max_distance = 70.0

func _ready() -> void:
	Inventory.connect("trigger_door_animation", on_trigger_door_animation_)
	scare_2.monitoring = false
	turn_off_sounds_and_have_npc_2_enter.monitoring = false


func _process(_delta: float) -> void:
#	need to add flag here
	background_scary_audio_scare_()
#	check inventory for item
	if player_in_area and Input.is_action_just_pressed("place"):
		Inventory.check_if_player_has_item("Library Key")
		
		

func _on_door_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
#		detects when player is in door area3d
		player_in_area = true
	if body.name == "NPC_2":
		print("ring bell for npc_2 in library script")
		bell_sound.play()
	
func _on_inventory_book_item_book_collected() -> void:
	#here i make new mission to set books down
#	bring it to the front desk
	print("bring books to front desk")
#	erase bools from inventory
	pass # Replace with function body.



func _on_front_desk_area_3d_body_entered(body: Node3D) -> void:
	if not body.is_in_group("books"):
		return
		
	var book_name = body.book_name.to_lower()

	# nly specific books allowed
	if not required_books.has(book_name):
		return

	# prevent counting same book twice
	if counted_books.has(book_name):
		return

	# Count it
	counted_books.append(book_name)
	counter += 1

	print("Book added:", book_name)
	print("Counter = ", counter)
	receptionist_label.text = "Books " + str(counter) + " / 2 ⬇️"
	check_completion()
	
func check_completion():
	if counter == required_books.size():
		print("All required books returned!")
		SignalManager.emit_signal("scene1_return_books_to_shelf")
		await get_tree().create_timer(5).timeout
		receptionist_label.text = ""


func on_trigger_door_animation_():
#	trigger door animation here
	door_anim_player.play("Open_Door")
	print("trigger door animation here")
	misson_manager.set_message("Put books onto front desk")
	pass
	
	

func _on_coffee_machine_trigger_despawn_spook_1_coffe_finished() -> void:
	spook_1.queue_free()
	cutscene_2.monitoring = true



func _on_cutscene_2_body_entered(body: Node3D) -> void:
	if body.name == "Player" && Global.played_cutscene_1 == true && bell_has_been_fired == false:
		player.force_look_at(look_target.global_position)
		bell_sound.play()
		Global.move_npc_1_to_desk_after_bell_rings = true
		print("Bell triggered")
		bell_has_been_fired = true


func background_scary_audio_scare_():
	if Global.background_scary_ambience and Global.npc_1_last_dialogue_is_finished_enabler_for_bg_sound_footsteps:
		var distance = player.global_transform.origin.distance_to(scary_object.global_transform.origin)
		
		# Clamp distance so it doesn't go negative or exceed max
		distance = clamp(distance, 0, max_distance)
		
		# Map distance to volume: closer = louder
		# volume_db: 0 is full volume, -80 is silent
		var volume_factor = lerp(0, -30, distance / max_distance)  # adjust -30 to taste
		scary_background_audio.volume_db = volume_factor
		
		# Optionally vary pitch for creepiness
		scary_background_audio.pitch_scale = randf_range(0.95, 1.05)
		
		# Ensure audio is playing
		if not scary_background_audio.playing:
			scary_background_audio.play()


func _on_scare_2_body_entered(body: Node3D) -> void:
	if body.name == "Player" and Global.npc_1_last_dialogue_is_finished_enabler_for_bg_sound_footsteps == true:
		Global.background_scary_ambience = true
		Global.disable_ghost_footsteps = true
		print("Player activated sound here")
#		this monitoring stuff needs to be checked
		turn_off_sounds_and_have_npc_2_enter.monitoring = true
		pass # Replace with function body.


func _on_turn_off_sounds_and_have_npc_2_enter_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		Global.background_scary_ambience = false
		Global.disable_ghost_footsteps = false
		Global.npc_1_last_dialogue_is_finished_enabler_for_bg_sound_footsteps = false
		print("Player de-activate sound here")
		pass # Replace with function body.

#i need to i=fix the decrement
func _on_front_desk_area_3d_body_exited(body: Node3D) -> void:
	if not body.is_in_group("books"):
		return
		
	var book_name = body.book_name.to_lower()

	# nly specific books allowed
	if not required_books.has(book_name):
		return

	# prevent counting same book twice
	if counted_books.has(book_name):
		return

	# Count it
	#counted_books.append(book_name)
	counter -= 1

	print("Book added:", book_name)
	print("Counter = ", counter)
	receptionist_label.text = "books " + str(counter) + " / 2"
	#check_completion()
