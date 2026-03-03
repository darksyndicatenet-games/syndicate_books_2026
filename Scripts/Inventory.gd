extends Node
signal trigger_door_animation
var items := {}

@onready var door_animation_player: AnimationPlayer = $"../Day1/Door/door/AnimationPlayer"

func add_item(item_name: String):
	if items.has(item_name):
		items[item_name] += 1
	else:
		items[item_name] = 1

func remove_item(item_name: String):
	if items.has(item_name):
		items[item_name] -= 1
		if items[item_name] <= 0:
			items.erase(item_name)

func get_items() -> Dictionary:
	return items


func check_if_player_has_item(inventoryItem : String):
	#loop thru dictionary
	#check if it matches the inventoryItem
	#if so return value
	if items.has("Library Key"):
		Inventory.remove_item(inventoryItem)
		print( inventoryItem+ " was used!!!!!!!!!!!!!!!!")
		trigger_door_animation_()
		
	elif items.has(inventoryItem):
		Inventory.remove_item(inventoryItem)
		print( inventoryItem+ " was used")
		
	else:
		print(inventoryItem+" not found")

func trigger_door_animation_():
	emit_signal("trigger_door_animation")
