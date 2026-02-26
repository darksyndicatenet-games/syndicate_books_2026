extends CharacterBody3D


var has_player_interacted01:= false

#connect signal here in begin dialogue


func begin_dialogue():
	if has_player_interacted01 == false:
		Dialogic.start("scare1_spook1")
		has_player_interacted01 = true
	else:
		return
