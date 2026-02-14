extends Node

signal object_state_changed(is_holding: bool)

var is_holding := false

func set_holding(state: bool):
	is_holding = state
	emit_signal("object_state_changed", state)
	print("gloablw roks")


#only one item can be carried, either oen can be added(so carrying milk and add it to cup, or carrying cup and clicking on milk adds it)
