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
func set_holding(state: bool):
	is_holding = state
	emit_signal("object_state_changed", state)
	print("gloablw roks")


#only one item can be carried, either oen can be added(so carrying milk and add it to cup, or carrying cup and clicking on milk adds it)
