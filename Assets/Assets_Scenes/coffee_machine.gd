extends Node3D

@onready var coffee_machine_trigger: Area3D

func _ready() -> void:
	#coffee_machine_trigger = get_parent() as Area3D
	self.set_meta("display_name", "Coffee Machine")

func get_interact_text():
	return coffee_machine_trigger.get_interact_text()
