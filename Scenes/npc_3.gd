extends CharacterBody3D
#NPC_3
@export var target_marker: Node3D
@export var speed: float = 5.0
@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@export var look_marker: Marker3D
@onready var player: CharacterBody3D = $"../../Player"
@export var leave_marker : Marker3D
@onready var misson_manager: Node = $"../../MissonManager"
@onready var cutscene: Area3D = $"../../Day1/Door/Cutscene"

@onready var npc_2: CharacterBody3D = $"../NPC_2"
var npc3_event_triggered := false
# if npc_3_can_get_npc_2 == true make npc3 walk
func _ready() -> void:
	cutscene.monitoring = false
	if target_marker:
		nav_agent.target_position = target_marker.global_position

func _physics_process(_delta: float) -> void:
	if Global.npc_3_can_get_npc_2:
		enter_library()

		if Global.have_npc3_collect_npc_2_once and not npc3_event_triggered:
			npc3_event_triggered = true
			trigger_npc3_event()
		
		
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

@onready var npc2_nav_agent: NavigationAgent3D = $"../NPC_2/NavigationAgent3D"

func on_Beaded_charm_acquired_notification(argument: String):
	
	if argument == "Beaded_charm_acquired_notification":
			print("player gains charm and leaves")

			# Wait 2 seconds
			await get_tree().create_timer(2.0).timeout

			# Make NPC leave
			if leave_marker:
				nav_agent.target_position = leave_marker.global_position
				
			# Make NPC_2 leave at the same time
			if npc_2 and leave_marker:
				if npc2_nav_agent:
					npc2_nav_agent.target_position = leave_marker.global_position
			misson_manager.set_message("Close Library")
			#[Dialogue: "Guess it's time to lock up..."]
func trigger_npc3_event():
	if not Global.have_npc3_collect_npc_2_once:
		return

	Global.have_npc3_collect_npc_2_once = false

	enter_library()
	Dialogic.start("npc_3_enters_to_get_her_dad")
	if not Dialogic.signal_event.is_connected(on_Beaded_charm_acquired_notification):
		Dialogic.signal_event.connect(on_Beaded_charm_acquired_notification)

	await get_tree().create_timer(3.0).timeout
	
	player.force_look_at(look_marker.global_position)
	if Global.spook_1_ending == true:
		cutscene.monitoring = true
	else:
#		play credits
		return
