extends TextureRect

@onready var computer: Node3D = $"../.."
@onready var misson_manager: Node = $"../../../MissonManager"
@onready var error_message: Label = $"../ErrorMessage"
@onready var correct_message: Label = $"../CorrectMessage"

var books = {
	"the routledge handbook of philosophy of empathy": "Unknown Author",
	"animal farm": "George Orwell",
	"to kill a mockingbird": "Harper Lee",
	"python programming: the fundamental beginner's guide to learning python": "Thomas Jackson",
	"the power of your subconscious mind": "Jason Murphy"
}

@onready var user_name: LineEdit =$Control/UserName
@onready var password: LineEdit =$Control/Password
@onready var control: Control = $Control
@onready var logbook: Control = $"../Logbook"
@onready var user: TextureRect = $"."
@onready var log_: TextureRect = $"../Logbook/Log"

# page 2
@onready var book_name: LineEdit = $"../Logbook/Log/BookName"
@onready var author: LineEdit = $"../Logbook/Log/Author"
@onready var issued: LineEdit = $"../Logbook/Log/Issued"
@onready var returned: LineEdit = $"../Logbook/Log/Returned"
@onready var fine: LineEdit = $"../Logbook/Log/Fine"
@onready var taken_out_by: LineEdit = $"../Logbook/Log/TakenOutBy"
@onready var help_2: Sprite2D = $"../Logbook/Help2"
@onready var exit: TextureButton = $"../Logbook/Exit"

# entry item vars
@onready var entry_list: VBoxContainer = $"../EntryItem"
var entry_scene = preload("res://Scenes/entry_item.tscn")
var submitted_books: Array[String] = []

var required_books: Array[String] = [
	"the song of achilles",
	"animal farm"
]

# cutscene and spook
@onready var cutscene: Area3D = $"../../../Scare_1/Cutscene"
@onready var cutscene_2: Area3D = $"../../../Scare_1/Cutscene2"
@onready var cutscene_3: Area3D = $"../../../Scare_1/Cutscene3"
@onready var spook_1: CharacterBody3D = $"../../../Scare_1/Spook_1"

func _ready() -> void:
	SignalManager.connect("scene1_return_books_to_shelf", on_scene1_return_books_to_shelf)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	logbook.visible = false
	error_message.visible = false
	exit.visible = true
	help_2.visible = true
	entry_list.visible = false
	spook_1.visible = false

	# Automatically fill the returned field with today's date
	var today_dict = Time.get_datetime_dict_from_system()
	returned.text = str(today_dict.year) + "-" + str(today_dict.month).pad_zeros(2) + "-" + str(today_dict.day).pad_zeros(2)

func _on_btn_enter_pressed() -> void:
	if user_name.text == "zee" and password.text == "zee":
		control.visible = false
		logbook.visible = true
		user.visible = false
		log_.visible = true
		entry_list.visible = true
	else:
		error_message_function("Username or password incorrect")


func error_message_function(message: String):
	error_message.visible = true
	error_message.text = message
	await get_tree().create_timer(2.0).timeout
	error_message.visible = false

func find_book_node_by_name(book_title: String) -> RigidBody3D:
	for book in get_tree().get_nodes_in_group("books"):
		if book is RigidBody3D and book.book_name.to_lower() == book_title.strip_edges().to_lower():
			return book
	return null

func parse_date_to_unix(date_str: String) -> int:
	var parts = date_str.split("-")
	if parts.size() != 3:
		return 0
	var year = int(parts[0])
	var month = int(parts[1])
	var day = int(parts[2])
	return Time.get_unix_time_from_datetime_dict({
		"year": year,
		"month": month,
		"day": day,
		"hour": 0,
		"minute": 0,
		"second": 0
	})

# Validate date format YYYY-MM-DD
func is_valid_date_format(date_str: String) -> bool:
	var parts = date_str.split("-")
	if parts.size() != 3:
		return false
	for p in parts:
		if not p.is_valid_int():
			return false
	return true

func _on_btn_enter_2_pressed() -> void:
	# Get all entered values
	var entered_book_name = book_name.text.strip_edges().to_lower()
	var entered_author = author.text.strip_edges()
	var entered_issued = issued.text.strip_edges()
	var entered_returned = returned.text.strip_edges()
	var entered_fine = fine.text.strip_edges()
	var entered_taken_out_by = taken_out_by.text.strip_edges().to_lower()

	# Validate date formats
	if not is_valid_date_format(entered_issued):
		error_message_function("Issued date must be YYYY-MM-DD")
		return
	if not is_valid_date_format(entered_returned):
		error_message_function("Return date must be YYYY-MM-DD")
		return

	# Validate fine is a number
	if not entered_fine.is_valid_float():
		error_message_function("Fine must be a number")
		return

	# Find book node
	var book_node = find_book_node_by_name(entered_book_name)
	if not book_node:
		error_message_function("Book not found in the scene!")
		print("Book not found in the scene!")
		return

	# Check all data
	var book_name_correct = book_node.book_name.to_lower() == entered_book_name
	var author_correct = book_node.author.to_lower() == entered_author.to_lower()
	var issued_correct = book_node.issue_date == entered_issued
	var taken_out_by_correct = book_node.taken_out_by.to_lower() == entered_taken_out_by.to_lower()

	var today_dict = Time.get_datetime_dict_from_system()
	var today_string = str(today_dict.year) + "-" + str(today_dict.month).pad_zeros(2) + "-" + str(today_dict.day).pad_zeros(2)
	var returned_correct = entered_returned == today_string

	var fine_calculated = book_node.calculate_fine_for_return(entered_returned)
	var fine_correct = is_equal_approx(float(entered_fine), fine_calculated)

	if book_name_correct and author_correct and issued_correct and returned_correct and fine_correct and taken_out_by_correct:
		if submitted_books.has(entered_book_name):
			error_message_function("This book has already been submitted!")
			return
		add_entry_to_log()
		submitted_books.append(entered_book_name)
		
		check_first_npc_book()
		
		if check_required_books():
			print("Both require books submitted")
			SignalManager.emit_signal("scene1_return_books_to_shelf")
			misson_manager.set_message("Put books into shelves - alphabetical order")
		correct_message.text = "All entries are correct!"
	else:
		if not book_name_correct:
			error_message_function("- Book name is wrong")
		if not author_correct:
			error_message_function("- Author is wrong")
		if not issued_correct:
			error_message_function("- Issued date is wrong")
		if not returned_correct:
			error_message_function("- Return date is wrong")
		if not fine_correct:
			error_message_function("- Fine is wrong")
		if not taken_out_by_correct:
			error_message_function("- Taken out by is wrong")

func add_entry_to_log():
	var entry = entry_scene.instantiate()
	entry.get_node("HBoxContainer/BookNameLabel").text = book_name.text
	entry.get_node("HBoxContainer/AuthorLabel").text = author.text
	entry.get_node("HBoxContainer/IssuedLabel").text = issued.text
	entry.get_node("HBoxContainer/ReturnedLabel").text = returned.text
	entry.get_node("HBoxContainer/FineLabel").text = fine.text
	entry_list.add_child(entry)

func check_required_books() -> bool:
	for book in required_books:
		if not submitted_books.has(book):
			return false
	return true

# Hide validation messages and reset UI
func _on_exit_2_pressed() -> void:
	log_.visible = false
	entry_list.visible = false
	logbook.visible = false
	error_message.visible = false
	correct_message.visible = false
	control.visible = true
	user.visible = true
	user_name.text = ""
	password.text = ""
	book_name.text = ""
	author.text = ""
	issued.text = ""
	returned.text = ""
	fine.text = ""
	taken_out_by.text = ""
	computer.end_interaction()

func _on_help_pressed() -> void:
	help_2.visible = true
	exit.visible = true

func _on_exit_pressed() -> void:
	help_2.visible = false
	exit.visible = false

func on_scene1_return_books_to_shelf():
	SignalManager.prompt_scene1_return_books_to_shelf = true
	misson_manager.set_message("Log books into computer")
	print("scene1_return_books_to_shelf, next mission since books are entered")


# Call this function at the end of your _on_btn_enter_2_pressed function
func check_first_npc_book() -> void:
	var entered_book_name = book_name.text.strip_edges().to_lower()
	var entered_author = author.text.strip_edges().to_lower()
	var entered_issued = issued.text.strip_edges()
	var entered_returned = returned.text.strip_edges()
	var entered_taken_out_by = taken_out_by.text.strip_edges().to_lower()
	var entered_fine = fine.text.strip_edges()

	# Only check for "animal farm"
	if entered_book_name != "to kill a mockingbird":
		return  # Do nothing if it's not the first NPC's book

	var book_node = find_book_node_by_name(entered_book_name)
	if not book_node:
		print("Book not found in scene for first NPC check")
		return

	var today_dict = Time.get_datetime_dict_from_system()
	var today_string = str(today_dict.year) + "-" + str(today_dict.month).pad_zeros(2) + "-" + str(today_dict.day).pad_zeros(2)

	var book_name_correct = book_node.book_name.to_lower() == entered_book_name
	var author_correct = book_node.author.to_lower() == entered_author
	var issued_correct = book_node.issue_date == entered_issued
	var returned_correct = entered_returned == today_string
	var taken_out_by_correct = book_node.taken_out_by.to_lower() == entered_taken_out_by
	var fine_calculated = book_node.calculate_fine_for_return(entered_returned)
	var fine_correct = is_equal_approx(float(entered_fine), fine_calculated)

	if book_name_correct and author_correct and issued_correct and returned_correct and taken_out_by_correct and fine_correct:
		Global.check_book_first_npc = true
		print("First NPC book entered correctly. Global.check_book_first_npc = true")
	else:
		Global.check_book_first_npc = false
		print("First NPC book entry incorrect. Global.check_book_first_npc = false")


func _on_exit_login_pressed() -> void:
	#user.visible = false
	computer.end_interaction()
	pass # Replace with function body.
