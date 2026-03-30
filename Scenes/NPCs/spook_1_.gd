extends CharacterBody3D

@onready var misson_manager: Node = $"../../MissonManager"

var has_player_interacted01:= false

#connect signal here in begin dialogue

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
		misson_manager.set_message("Get coffee from staff room coffee machine")
		Global.spook_1_ending = true
#		this unlocks the ending
		
		
func on_player_denied_coffee_For_spook():
#	play credits
	pass
