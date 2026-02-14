extends Area3D

@export var ingredient_name: String = "milk"
@onready var decal: Decal = $Decal
@export var item_name = ""

func _ready():
	self.set_meta("display_name", item_name)

func interact(player):
	#if player.current_cup:
		#player.current_cup.add_ingredient(ingredient_name)
		#print("Added ", ingredient_name)
	#else:
		#print("You need a cup first!")


	player.current_cup = self
	
	# remove from world
	var parent = get_parent()
	if parent:
		parent.remove_child(self)
	
	# attach to player's hand
	player.Hand.add_child(self)
	
	# reset to hand's location
	self.transform = Transform3D.IDENTITY    
	#decal.visible = true
	print("Picked up: ", item_name)
	Global.set_holding(true)
