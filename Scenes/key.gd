extends RigidBody3D


@onready var inventory_item: Area3D = $InventoryItem
@onready var key: RigidBody3D = $"."
@export var interact_message: String = "Press E to take key"

@export var item_name: String = "Library Key"
@onready var misson_manager: Node = $"../../MissonManager"


var player_in_area := false

func _on_body_entered(body):
	if body.name == "Player":
		player_in_area = true

func _on_body_exited(body):
	if body.name == "Player":
		player_in_area = false

func _process(_delta):
#	collects key?
	if player_in_area and Input.is_action_just_pressed("place"):
		Inventory.add_item(item_name)
		queue_free()

		#wjat


func _on_inventory_item_key_collected() -> void:
#	collect keys
	key.queue_free()
	misson_manager.complete_mission()

func get_interact_text():
	return interact_message
