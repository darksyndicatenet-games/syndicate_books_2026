extends CharacterBody3D
#NPC_3
@export var target_marker: Node3D
@export var speed: float = 3.0
@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D


# if npc_3_can_get_npc_2 == true make npc3 walk
func _ready() -> void:

	if target_marker:
		nav_agent.target_position = target_marker.global_position

func _physics_process(_delta: float) -> void:
	if Global.npc_3_can_get_npc_2:
		enter_library()
		
		
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
