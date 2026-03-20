extends RigidBody3D

@export var item_name: String = "Stack of Books"
signal book_collected
var player_in_area := false
@onready var misson_manager: Node = $"../../MissonManager"

@export var interact_message: String = "Press E to take Stack of Books"

func _process(_delta):
	if player_in_area and Input.is_action_just_pressed("place"):
		Inventory.add_item(item_name)
		queue_free()
		#misson_manager.set_message("Collect Key")
		emit_signal("book_collected")


func _on_inventory_book_item_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		player_in_area = true


func _on_inventory_book_item_body_exited(body: Node3D) -> void:
	if body.name == "Player":
		player_in_area = false
		
func get_interact_text():
	return interact_message
