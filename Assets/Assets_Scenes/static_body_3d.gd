extends StaticBody3D


@export var interact_message: String = "Press E to interact"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	self.set_meta("display_name", "Coffee Machine")

func get_interact_text():
	return interact_message
