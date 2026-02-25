extends Area3D

@export var item_name: String = "Stack of Books"
signal book_collected
var player_in_area := false

func _on_body_entered(body):
	if body.name == "Player":
		player_in_area = true

func _on_body_exited(body):
	if body.name == "Player":
		player_in_area = false

func _process(_delta):
	if player_in_area and Input.is_action_just_pressed("place"):
		Inventory.add_item(item_name)
		queue_free()
		emit_signal("book_collected")
