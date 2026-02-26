extends Node3D

var player_in_area:= false
func _process(_delta: float) -> void:
	if player_in_area and Input.is_action_just_pressed("place"):
		Inventory.check_if_player_has_item("Library Key")

func _on_door_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_in_area = true
		


func _on_inventory_book_item_book_collected() -> void:
	#here i make new mission to set books down
#	bring it to the front desk
	print("bring books to front desk")
#	erase bools from inventory
	pass # Replace with function body.


func _on_front_desk_area_3d_area_entered(area: Area3D) -> void:
	if area.is_in_group("books"):
		print(area)


func _ready() -> void:
	Dialogic.start("scare1_spook1")
