extends CharacterBody3D

@onready var misson_manager: Node = $"../../MissonManager"
@onready var user: TextureRect = $"../../Computer/CanvasLayer/User"

@onready var cutscene_3: Area3D = $Cutscene3

@export var target_marker: Node3D
@export var speed: float = 3.0
@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var move_outside: Marker3D = $move_outside

var npc_1_is_finished_So_move_outside:= false
var has_player_interacted01:= false


var check_book_first_npc_play_once := false
func _ready():
	if target_marker:
		nav_agent.target_position = target_marker.global_position
		npc_1_is_finished_So_move_outside = true
	cutscene_3.monitoring = false

func _physics_process(_delta):
	if Global.move_npc_1_to_desk_after_bell_rings:
		if nav_agent.is_navigation_finished():
			velocity = Vector3.ZERO

			# Check if player entered the book correctly
			if Global.check_book_first_npc == false:
				user.check_book_for_first_npc()

			# If book is correct, player has left screen, and dialogue hasn't played yet
			if Global.check_book_first_npc and Global.player_exited_the_screen and check_book_first_npc_play_once == false:
				check_book_first_npc_play_once = true  # mark as done
				await handle_npc_after_book()  # async function handles dialogue + movement

			return

		# Move NPC toward next navigation point
		var next_position = nav_agent.get_next_path_position()
		var direction = (next_position - global_position).normalized()
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		move_and_slide()


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
	misson_manager.set_message("Look around the library if anyone is still inside.")

	# Wait until dialogue finishes (assuming Dialogic has a 'finished' signal)
	#await Dialogic.finished  # pause here until dialogue is done
#	basixally have a signal that emits when dialogue is finsihed 

	# Now move NPC outside
	target_marker = move_outside
	nav_agent.target_position = target_marker.global_position
