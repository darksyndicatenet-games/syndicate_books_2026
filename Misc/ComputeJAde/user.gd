extends TextureRect
@onready var computer: Node3D = $"../.."

#@onready var misson_manager: Node = $"../../../MissonManager"
@onready var misson_manager: Node = $"../../../MissonManager"

@onready var error_message: Label = $"../ErrorMessage"
@onready var correct_message: Label = $"../CorrectMessage"
var entry_visual_db
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

#page 2

@onready var book_name: LineEdit = $"../Logbook/Log/BookName"
@onready var author: LineEdit = $"../Logbook/Log/Author"
@onready var issued: LineEdit = $"../Logbook/Log/Issued"
@onready var returned: LineEdit = $"../Logbook/Log/Returned"
@onready var fine: LineEdit = $"../Logbook/Log/Fine"
@onready var taken_out_by: LineEdit = $"../Logbook/Log/TakenOutBy"
@onready var help_2: Sprite2D = $"../Logbook/Help2"

@onready var exit: TextureButton = $"../Logbook/Exit"

#entry item vars
@onready var entry_list: VBoxContainer = $"../EntryItem"
var entry_scene = preload("res://Scenes/entry_item.tscn")

var submitted_books: Array[String] = []

var required_books: Array[String] = [
	"the routledge handbook of philosophy of empathy",
	"animal farm"

]

func _ready() -> void:
	
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE) # Show cursor for UI
	logbook.visible = false
	error_message.visible = false
	
#	rule book
	exit.visible = true
	help_2.visible = true
	
#	signals
	SignalManager.scene1_return_books_to_shelf.connect(on_scene1_return_books_to_shelf)
	
#	entry items
	entry_list.visible = false
	


func _on_btn_enter_pressed() -> void:
	var entereed_user_name = user_name.text
	var entereed_password= password.text
	
	if user_name.text == "zee" && password.text == "zee":
		print(entereed_user_name)
		print(entereed_password)
		control.visible = false
		logbook.visible = true
		user.visible = false
		log_.visible = true
		entry_list.visible = true
	else:
		print("error username and password incorrect")
		#throw an error here visible to player


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
		#push_error("Invalid date format: " + date_str)
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

func _on_btn_enter_2_pressed() -> void:
			# Check if player entered the book correctly
	if Global.check_book_first_npc == false:
		user.check_book_for_first_npc()
	var entered_book_name = book_name.text.strip_edges().to_lower()
	var entered_author = author.text.strip_edges()
	var entered_issued = issued.text.strip_edges()
	var entered_returned = returned.text.strip_edges()
	var entered_fine = fine.text.strip_edges()
	var entered_taken_out_by = taken_out_by.text.strip_edges()

	var book_node = find_book_node_by_name(book_name.text)
	if not book_node:
		
		error_message_function("Book not found in the scene!")
		print("Book not found in the scene!")
		
		return

	# Compare book name and author
	var book_name_correct = book_node.book_name.to_lower() == entered_book_name
	var author_correct = book_node.author.to_lower() == entered_author.to_lower()
	var issued_correct = book_node.issue_date == entered_issued
	var taken_out_by_correct = book_node.taken_out_by.to_lower() == entered_taken_out_by.to_lower()
	
	# Get today's system date
	var today_dict = Time.get_datetime_dict_from_system()

	var today_string = str(today_dict.year) + "-" + \
		str(today_dict.month).pad_zeros(2) + "-" + \
		str(today_dict.day).pad_zeros(2)

	# Check if entered return date matches today's date
	var returned_correct = entered_returned == today_string
	var returned_unix = parse_date_to_unix(entered_returned)
	# Calculate fine based on returned date
	var fine_calculated = book_node.calculate_fine_for_return(entered_returned)
	#var fine_correct = float(entered_fine) == fine_calculated
	var fine_correct = is_equal_approx(float(entered_fine), fine_calculated)
	
	print("Entered fine:", float(entered_fine))
	print("Calculated fine:", fine_calculated)

	# No need to compare returned directly to due_date
	#var returned_correct = true 
	# any valid returned date is acceptable

	if book_name_correct and author_correct and issued_correct and returned_correct and fine_correct and taken_out_by_correct:
			# ✅ Prevent duplicate submission
		if submitted_books.has(entered_book_name):
			error_message_function("This book has already been submitted!")
			return
#		addd visually on database
		add_entry_to_log()
#add lowercase for consistency
		submitted_books.append(entered_book_name)
		
	# Check if required books are all submitted
		if check_required_books():
			print("Both required books submitted! Firing signal...")
			SignalManager.emit_signal("scene1_return_books_to_shelf")
		correct_message.text = "All entries are correct!"

	else:
		
		print("Some entries are incorrect:")
		if not book_name_correct:
			print("- Book name is wrong")
			error_message_function("- Book name is wrong")
		if not author_correct:
			print("- Author is wrong")
			error_message_function("- Author is wrong")
		if not issued_correct:
			print("- Issued date is wrong")
			error_message_function("- Issued date is wrong")
		if not fine_correct:
			print("- Fine is wrong")
			error_message_function("- Fine is wrong")
		if not returned_correct:
			print("- Return Date is wrong")
			error_message_function("- Return Date is wrong")
			
		if not taken_out_by_correct:
			print("- Taken out by is wrong")
			error_message_function("- Taken out by is wrong")


func _on_help_pressed() -> void:
	help_2.visible = true
	exit.visible = true

func _on_exit_pressed() -> void:
	help_2.visible = false
	exit.visible = false



func _on_exit_2_pressed() -> void:
	log_.visible = false
	entry_list.visible = false
	logbook.visible = false
	
	# hide messages
	error_message.visible = false
	correct_message.visible = false
	
	# reset login screen
	control.visible = true
	user.visible = true
	
	# clear all input fields
	user_name.text = ""
	password.text = ""
	book_name.text = ""
	author.text = ""
	issued.text = ""
	returned.text = ""
	fine.text = ""
	taken_out_by.text = ""

	computer.end_interaction()
	
	

	

func on_scene1_return_books_to_shelf():
	SignalManager.prompt_scene1_return_books_to_shelf = true
	#misson_manager.set_message("Return books to shelf")
	print("scene1_return_books_to_shelf, next mission since books are entered")
	misson_manager.set_message("Pack Books into shelfs")
#	this needs checking

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


#so i need ti=o make text invisvible once i exit the computer
#the validation message still show - needa to be invisible

func check_book_for_first_npc() -> bool:
	var correct_book_name = "animal farm"
	var correct_author = "George Orwell"

	var entered_book_name = book_name.text.strip_edges().to_lower()
	var entered_author = author.text.strip_edges().to_lower()
	var entered_issued = issued.text.strip_edges()
	var entered_returned = returned.text.strip_edges()
	var entered_taken_out_by = taken_out_by.text.strip_edges().to_lower()
	var entered_fine = fine.text.strip_edges()

	# Find the actual book node in the scene
	var book_node = find_book_node_by_name(entered_book_name)
	if not book_node:
		print("Book not found in the scene")
		Global.check_book_first_npc = false
		return false

	# Check all required fields
	var name_correct = entered_book_name == correct_book_name
	var author_correct = entered_author == correct_author.to_lower()
	var issued_correct = entered_issued == book_node.issue_date
	var taken_out_by_correct = entered_taken_out_by == book_node.taken_out_by.to_lower()

	# Calculate fine based on dates
	var returned_unix = parse_date_to_unix(entered_returned)
	var issue_unix = parse_date_to_unix(book_node.issue_date)
	var days_kept = int((returned_unix - issue_unix) / 86400)
	var fine_calculated = 0.0
	if days_kept > book_node.allowed_days:
		fine_calculated = (days_kept - book_node.allowed_days) * book_node.fine_per_day
	#var fine_correct = float(entered_fine) == fine_calculated
	var fine_correct = is_equal_approx(float(entered_fine), fine_calculated)


	# If everything matches, mark as correct
	if name_correct and author_correct and issued_correct and taken_out_by_correct and fine_correct:
		print("All data for first NPC book correct.")
		Global.check_book_first_npc = true
		return true
	else:
		print("Some data is incorrect for the first NPC book.")
		Global.check_book_first_npc = false
		return false
