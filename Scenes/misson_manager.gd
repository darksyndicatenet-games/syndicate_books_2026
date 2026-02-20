extends Node

@onready var mission_ui = $"../TriggerThoughts/FadeText"

var current_mission := 0

@export_multiline var missions: PackedStringArray = [
	"Find Key inside of return box outside of the library",
	"Pick up the book.",
	"Enter the correct log details.",
	"Return the book before the due date."
]


func _ready():
	show_current_mission()


func show_current_mission():
	if current_mission < missions.size():
		mission_ui.set_message(missions[current_mission])
		mission_ui.play_fade()


func complete_mission():
	current_mission += 1
	show_current_mission()
	
	
#get_node("MissionManager").complete_mission()
#func _on_book_picked_up():
	#get_node("/root/Main/MissionManager").complete_mission()
	#
#if everything_correct:
	#get_node("MissionManager").complete_mission()
