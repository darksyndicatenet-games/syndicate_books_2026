extends Area3D
#once only?
#press e to intercat snap cup to the machine
@onready var coffee: MeshInstance3D = $Cup/coffee_mug/coffee
@export var interact_message: String = "Press E to interact"
@onready var coffee_machine_progress: ProgressBar = $coffee_machine/CoffeeMachineProgress
var player_in_area: bool = false  # Track if player is inside the area
@onready var misson_manager: Node = $"../../MissonManager"
var coffee_machine_activated = false
signal despawn_spook_1_coffe_finished
var cup_placed_once = false  # flag to make it happen only once
func _process(_delta: float) -> void:
	if player_in_area and not coffee_machine_activated:
		if Input.is_action_just_pressed("place"):
			print("Player pressed E")
			#misson_manager.set_message("coffee machine IS on")
			coffee_machine_activated = true  # prevent repeat
			print("Coffee is done")
			misson_manager.set_message("Give coffee to person studying")
			emit_signal("despawn_spook_1_coffe_finished")
#			so add a siganl here
#despawn that npc
			
#play animtion for coffee machine 
func _on_body_entered(body: Node3D) -> void:
	if body.name == "Player" and Global.player_placed_coffee_in_machine:
		player_in_area = true
		#print("Player entered coffee machine area")


func _on_placement_cup_placed_in_coffe_machine() -> void:
	if cup_placed_once:
		return  # do nothing if already triggered
	
	misson_manager.set_message("Turn coffee machine on")
	Global.player_placed_coffee_in_machine = true
	coffee.visible = true
	cup_placed_once = true  # prevent repeating

func _on_body_exited(body: Node3D) -> void:
	if body.name == "Player":
		player_in_area = false

func get_interact_text():
	if not player_in_area:
		return ""
	
	if not Global.player_placed_coffee_in_machine:
		return ""
	
	if coffee_machine_activated:
		return ""
	
	return "Press F to turn on coffee machine"
