extends CharacterBody3D
@onready var player: CharacterBody3D = $"../../Player"

@export var target_marker: Node3D
@export var speed: float = 3.0
@onready var misson_manager: Node = $"../../MissonManager"
@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@export var have_elderly_come_in_library_npc2 : bool 
var has_player_interacted01 = false
@export var look_marker: Node3D
var looking_timer := 0.0
var look_duration := 3.0
var is_looking := false
@export var leave_marker : Marker3D

func _ready() -> void:
	
	if target_marker:
		nav_agent.target_position = target_marker.global_position


func _physics_process(_delta: float) -> void:
	if Global.have_elderly_come_in_library_npc2_:
		enter_library()
	if Global.The_Long_Walk_To_Freedom_given_to_npc2:
		player.force_look_at(look_marker.global_position)
#		maybe add  an await for 1.5s
#add dialogue here
		Dialogic.start("hand_book_to_npc_2")
		Global.The_Long_Walk_To_Freedom_given_to_npc2 = false

func enter_library():
	if nav_agent.is_navigation_finished():
		velocity = Vector3.ZERO
		move_and_slide()
		return

	# Get next navigation point
	var next_position = nav_agent.get_next_path_position()

	# Calculate direction
	var direction = (next_position - global_position).normalized()

	# Move NPC
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed

	move_and_slide()
	
	
#	DIALOGUE
func begin_dialogue():
	if has_player_interacted01 == false:
		Dialogic.start("scare_3_npc_2")
		has_player_interacted01 = true
		Dialogic.signal_event.connect(on_You_phone_the_number_on_the_band)
		Dialogic.signal_event.connect(on_Get_The_Long_Walk_To_Freedom_Book_for_the_man)
	else:
		return

#func get_long_walk_of_freedom_book():

func on_Get_The_Long_Walk_To_Freedom_Book_for_the_man(argument : String):
	if argument == "Get_The_Long_Walk_To_Freedom_Book_for_the_man":
		print("Dialogic.signal_event(on_Get_The_Long_Walk_To_Freedom_Book_for_the_man) -true")
		Global.player_acquired_beaded_charm = true
		misson_manager.set_message("Get The Power Of Patience for the man")
		pass
func on_You_phone_the_number_on_the_band(argument : String):
#	black screen with You_phone_the_number_on_the_band
	if argument == "You_phone_the_number_on_the_band":
		print("You_phone_the_number_on_the_band")
		Global.npc_3_can_get_npc_2 = true
		print(Global.npc_3_can_get_npc_2, " npc_3_can_get_npc_2")
		Global.have_npc3_collect_npc_2_once = true

	pass
	
