extends CanvasLayer

@onready var panel = $Panel
@onready var label = $Panel/InventoryText

func _ready():
	panel.visible = false

func _process(_delta):
	if Input.is_action_just_pressed("ui_tab"):
		toggle_inventory()

func toggle_inventory():
	panel.visible = !panel.visible
	update_inventory_text()

func update_inventory_text():
	var text := ""
	for item in Inventory.get_items():
		text += str(Inventory.items[item]) + "x " + item + "\n"

	if text == "":
		text = "Inventory Empty"

	label.text = text
