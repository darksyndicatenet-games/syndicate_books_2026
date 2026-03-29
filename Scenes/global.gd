extends Node

signal object_state_changed(is_holding: bool)
var is_player_occupied:= false
var is_holding := false
var book_iCounter:= 0


var played_cutscene_1 := false
var move_npc_1_to_desk_after_bell_rings := false
var check_book_first_npc := false
var player_left_screen_npc_1 := false
#var start_said_npc_1_goodbye_dialgue := false

var player_placed_coffee_in_machine := false

var player_exited_the_screen:= false

var lock_all_player_controls_ := true
var npc_1_last_dialogue_is_finished_enabler_for_bg_sound_footsteps := false

var disable_ghost_footsteps:= false
var background_scary_ambience := false
var player_acquired_beaded_charm :=  false
var The_Long_Walk_To_Freedom_given_to_npc2:= false
var npc_3_can_get_npc_2:= false
var have_npc3_collect_npc_2_once:= false

var is_at_computer := false
var have_elderly_come_in_library_npc2_ := false

var spook_1_ending := false
func set_holding(state: bool):
	is_holding = state
	emit_signal("object_state_changed", state)
	print("gloablw roks")


#only one item can be carried, either oen can be added(so carrying milk and add it to cup, or carrying cup and clicking on milk adds it)
