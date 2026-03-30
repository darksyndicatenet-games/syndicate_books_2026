extends CharacterBody3D

@onready var misson_manager: Node = $"../../MissonManager"

var has_player_interacted01:= false
@onready var spook_1: CharacterBody3D = $"."

#connect signal here in begin dialogue
@onready var npc_1: CharacterBody3D = $"../NPC_1"

func _ready() -> void:
	set_meta("display_name", "???")
	Dialogic.signal_event.connect(on_player_denied_coffee_For_spook)

func begin_dialogue():
	if has_player_interacted01 == false:
		
		# ✅ Connect FIRST
		if not Dialogic.signal_event.is_connected(on_player_offered_coffee):
			Dialogic.signal_event.connect(on_player_offered_coffee)
		
		Dialogic.start("scare1_spook1")
		has_player_interacted01 = true

func on_player_offered_coffee(argument : String):
	if argument == "player_offered_coffee":
		print("Player chooses to offer coffee")
		misson_manager.set_message("Make coffee from staff room - coffee machine")
		Global.spook_1_ending = true
#		this unlocks the ending
	elif argument == "player_denied_coffee_For_spook":
		on_player_denied_coffee_For_spook()
@onready var cup: RigidBody3D = $"../CoffeeMachineTrigger/Cup"
@onready var bell_sound: AudioStreamPlayer3D = $"../Cutscene2/BellSound"

func on_player_denied_coffee_For_spook():
#	play credits
	misson_manager.set_message("Check front desk")
	Global.move_npc_1_to_desk_after_bell_rings = true
	npc_1.visible = true
	spook_1.queue_free()
	cup.queue_free()
	bell_sound.play()
