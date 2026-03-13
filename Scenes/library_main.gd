extends Node3D

@onready var receptionist_label_3d: Label3D = $NavigationRegion3D/Map/Misc/Desk/ReceptionistLabel3D
@onready var door_anim_player: AnimationPlayer = $Day1/Door/door/AnimationPlayer
@onready var bell_sound: AudioStreamPlayer3D = $Scare_1/Cutscene2/BellSound


var bell_has_been_fired := false
var counter := 0
#@onready var spook_1: CharacterBody3D = $Scare_1/Spook_1
@export var spook_1: CharacterBody3D
# books already counted
var counted_books: Array[String] = []

# ONLY these books should count
var required_books := [
	"animal farm",
	"the routledge handbook of philosophy of empathy"
]

@onready var cutscene_2: Area3D = $Scare_1/Cutscene2

var player_in_area:= false

func _ready() -> void:
	Inventory.connect("trigger_door_animation", on_trigger_door_animation_)


func _process(_delta: float) -> void:
#	check inventory for item
	if player_in_area and Input.is_action_just_pressed("place"):
		Inventory.check_if_player_has_item("Library Key")
		
		

func _on_door_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
#		detects when player is in door area3d
		player_in_area = true
		
		


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
	receptionist_label_3d.text = "books " + str(counter) + " / 2"
	check_completion()
	
func check_completion():
	if counter == required_books.size():
		print("All required books returned!")
		#SignalManager.emit_signal("scene1_return_books_to_shelf")


func on_trigger_door_animation_():
#	trigger door animation here
	door_anim_player.play("Open_Door")
	print("trigger door animation here")
	pass
	
	

func _on_coffee_machine_trigger_despawn_spook_1_coffe_finished() -> void:
	spook_1.queue_free()
	cutscene_2.monitoring = true



func _on_cutscene_2_body_entered(body: Node3D) -> void:
	if body.name == "Player" && Global.played_cutscene_1 == true && bell_has_been_fired == false:
		bell_sound.play()
		Global.move_npc_1_to_desk_after_bell_rings = true
		bell_has_been_fired = true
