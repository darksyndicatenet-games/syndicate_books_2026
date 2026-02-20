extends TextureRect


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

#page 2

@onready var book_name: LineEdit = $"../Logbook/Log/BookName"
@onready var author: LineEdit = $"../Logbook/Log/Author"
@onready var issued: LineEdit = $"../Logbook/Log/Issued"
@onready var returned: LineEdit = $"../Logbook/Log/Returned"
@onready var fine: LineEdit = $"../Logbook/Log/Fine"
@onready var taken_out_by: LineEdit = $"../Logbook/Log/TakenOutBy"
@onready var help_2: Sprite2D = $"../Logbook/Log/Help2"

@onready var exit: TextureButton = $"../Logbook/Log/Exit"

func _ready() -> void:
	exit.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE) # Show cursor for UI
	logbook.visible = false
	error_message.visible = false

func _on_btn_enter_pressed() -> void:
	var entereed_user_name = user_name.text
	var entereed_password= password.text
	print(entereed_user_name)
	print(entereed_password)
	control.visible = false
	logbook.visible = true
	user.visible = false
	log_.visible = true


func error_message_function(message: String):
	error_message.visible = true
	error_message.text = message
	await get_tree().create_timer(2.0).timeout
	error_message.visible = false

func find_book_node_by_name(name: String) -> RigidBody3D:
	for book in get_tree().get_nodes_in_group("books"):
		if book is RigidBody3D and book.book_name.to_lower() == name.strip_edges().to_lower():
			return book
	return null
func parse_date_to_unix(date_str: String) -> int:
	var parts = date_str.split("-")
	
	if parts.size() != 3:
		push_error("Invalid date format: " + date_str)
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

	# Calculate fine based on returned date
	var issue_unix = parse_date_to_unix(book_node.issue_date)
	var returned_unix = parse_date_to_unix(entered_returned)
	var days_kept = int((returned_unix - issue_unix) / 86400)
	var fine_calculated = 0.0
	if days_kept > book_node.allowed_days:
		fine_calculated = (days_kept - book_node.allowed_days) * book_node.fine_per_day

	var fine_correct = float(entered_fine) == fine_calculated

	# No need to compare returned directly to due_date
	var returned_correct = true  # any valid returned date is acceptable

	if book_name_correct and author_correct and issued_correct and returned_correct and fine_correct and taken_out_by_correct:
		correct_message.text = "All entries are correct!"
		print("All entries are correct!")
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
