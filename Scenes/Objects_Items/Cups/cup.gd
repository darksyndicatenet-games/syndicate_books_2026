extends Node3D

var ingredients: Array = []
@onready var decal: Decal = $Decal

@export var Small: bool = false


func _ready():
	self.set_meta("display_name", "Coffee Cup")
	decal.visible = false
	Small = true
	
func add_ingredient(ing: String):
	ingredients.append(ing)
	print("Cup now has: ", ingredients)

func interact(player):
	player.current_cup = self
	
	# remove from world
	var parent = get_parent()
	if parent:
		parent.remove_child(self)
	
	# attach to player's hand
	player.Hand.add_child(self)
	
	# reset to hand's location
	self.transform = Transform3D.IDENTITY    
	decal.visible = true
	print("Picked up cup")
	
#	signal hold an object
	Global.set_holding(true)
