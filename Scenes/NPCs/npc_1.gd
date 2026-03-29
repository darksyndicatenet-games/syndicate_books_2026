extends CharacterBody3D
#npc1 script
@onready var misson_manager: Node = $"../../MissonManager"
@onready var user: TextureRect = $"../../Computer/CanvasLayer/User"
@onready var computer: Node3D = $"../../Computer"

@onready var cutscene_3: Area3D = $"../Cutscene3"
@onready var player: CharacterBody3D = $"../../Player"

@export var target_marker: Node3D
@export var speed: float = 3.0
@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var move_outside: Marker3D = $move_outside
@onready var npc_1: CharacterBody3D = $"."

var npc_1_is_finished_So_move_outside:= false
var has_player_interacted01:= false
@onready var scare_2: Area3D = $"../Scare2"

var check_book_first_npc_play_once := false
func _ready():
	
	if target_marker:
		nav_agent.target_position = target_marker.global_position
		npc_1_is_finished_So_move_outside = true
		
	cutscene_3.monitoring = false

var npc_should_leave := false  # ADD THIS at the top with your other vars

func _physics_process(_delta):
	if Global.move_npc_1_to_desk_after_bell_rings:

		# --- NEW: handle leave movement separately ---
		if npc_should_leave:
			if not nav_agent.is_navigation_finished():
				var next_position = nav_agent.get_next_path_position()
				var direction = (next_position - global_position).normalized()
				velocity.x = direction.x * speed
				velocity.z = direction.z * speed
			else:
				velocity = Vector3.ZERO
			move_and_slide()
			return
		# --- end new block ---

		if nav_agent.is_navigation_finished():
			velocity = Vector3.ZERO
			if not check_book_first_npc_play_once and Global.check_book_first_npc:
				check_book_first_npc_play_once = true
				handle_npc_after_book()
			move_and_slide()
			return

		var next_position = nav_agent.get_next_path_position()
		var direction = (next_position - global_position).normalized()
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		move_and_slide()

#func on_npc1_can_leave_library(argument: String):
	#await get_tree().create_timer(4.0).timeout
	#if argument == "npc1 can leave library":
		#print("have npc walk away then")
		#nav_agent.target_position = move_outside.global_position
		#npc_should_leave = true  # ← THIS is what actually restarts movement


func begin_dialogue():
	if has_player_interacted01 == false:
		Dialogic.start("greeting_with_npc_1")
		has_player_interacted01 = true
		Dialogic.signal_event.connect(on_log_book_return_into_computer)
		Global.player_left_screen_npc_1 = true #change this name to player_had_been_spoken too
	else:
		return
func last_dialogue():
#	this needs to automacially play once player leaves computer screen ONCE

	Dialogic.start("check_if_npc_1_saw_someone_leave")
	if nav_agent.is_navigation_finished():
		target_marker = move_outside
		nav_agent.target_position = target_marker.global_position
		misson_manager.set_message("Search Study Area")
		Global.npc_1_last_dialogue_is_finished_enabler_for_bg_sound_footsteps = true
		scare_2.monitoring = true
		Global.have_elderly_come_in_library_npc2_ = true
		
		
func on_log_book_return_into_computer(argument : String):
	if argument == "log_book_return_into_computer":
		print("log_book_return_into_computer")
	misson_manager.set_message("Log book return into computer")
#	so there needs to be a book here that player needs to log back in
func handle_npc_after_book() -> void:
	# wait 1 second before starting dialogue
	await get_tree().create_timer(1.0).timeout

	# start the dialogue
	print("Player entered book correctly & exited screen")
	cutscene_3.monitoring = true
	last_dialogue()
	misson_manager.set_message("Put coffee in tray on receptionist desk")
	
	# Wait until dialogue finishes (assuming Dialogic has a 'finished' signal)
	#await Dialogic.finished  # pause here until dialogue is done
#	basixally have a signal that emits when dialogue is finsihed 
	Dialogic.signal_event.connect(on_npc1_can_leave_library)
	# Now move NPC outside
	

func on_npc1_can_leave_library(argument : String):
	await get_tree().create_timer(4.0).timeout
	if argument == "npc1 can leave library":
		print("have npc walk away then")
		target_marker = move_outside
		nav_agent.target_position = target_marker.global_position
		
	pass
#npc_1.queue_free()
