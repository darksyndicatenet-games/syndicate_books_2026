extends Node

#@onready var mission_ui = $"../TriggerThoughts/FadeText"
var message: String = ""
var current_mission := 0
#@onready var label: Label = $"../TriggerThoughts/FadeText/Label"

@onready var misson_label: Label = $"../TriggerThoughts/FadeText/MissonLabel"

@export_multiline var missions: PackedStringArray = [
	"Find Key inside of return box outside of the library"
]


func _ready():
	misson_label.text = message
	#misson_label.modulate.a = 0.0
	show_current_mission()


func show_current_mission():
	if current_mission < missions.size():
		set_message(missions[current_mission])

func complete_mission():
	current_mission += 1
	show_current_mission()
	#mission_ui.play_fade()
	
func set_message(new_text: String):
	message = new_text
	misson_label.text = new_text
#get_node("MissionManager").complete_mission()
#func _on_book_picked_up():
	#get_node("/root/Main/MissionManager").complete_mission()
	#
#if everything_correct:
	#get_node("MissionManager").complete_mission()
