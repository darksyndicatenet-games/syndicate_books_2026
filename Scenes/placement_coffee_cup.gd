extends Area3D
@onready var object_placed: Marker3D = $ObjectPlaced

var body_inside: RigidBody3D = null
#@onready var door: CSGBox3D = $"../../Map/Misc/Door"

signal cup_placed_in_coffe_machine
@onready var cup: RigidBody3D = $"../../../Scare_1/CoffeeMachineTrigger/Cup"


func _physics_process(_delta: float) -> void:
	if body_inside and Input.is_action_just_pressed("place"):
		move_to_marker(body_inside, object_placed)
		print("placed")
		emit_signal("cup_placed_in_coffe_machine")
		Global.player_placed_coffee_in_machine = true
	
	
func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("cups"):
		body_inside = body


func move_to_marker(body: Node3D, marker: Marker3D):
	body.freeze = true
	body.linear_velocity = Vector3.ZERO
	body.angular_velocity = Vector3.ZERO
	body.global_transform = marker.global_transform
	if body.name == "TheLongWalkToFreedom":
		print("TheLongWalkToFreedom -- true")
		Global.The_Long_Walk_To_Freedom_given_to_npc2 = true
	if body.name == "Cup":
		print("coffee cup planted")
		cup.collision_layer = 1
		cup.collision_mask = 1
		#have coffee mug static here

func _on_body_exited(body: Node3D) -> void:
	if body == body_inside:
		body_inside = null
