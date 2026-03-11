extends RigidBody3D

# -------------------------
# Exported Book Properties
# -------------------------
@export var book_name: String
@export var author: String
@export var taken_out_by: String
@export var issue_date: String = "2025-01-01" # YYYY-MM-DD
@export var fine_per_day: float = 2.0
#@export var book_id: String = "001"
@export var is_held = false
# -------------------------
# Internal Tracking
# -------------------------
var allowed_days := 14
var days_kept := 0
var fine_amount := 0.0
var due_date: String = ""

# -------------------------
# Ready
# -------------------------
func _ready():
	calculate_book_info()
	self.set_meta("display_name", book_name)

# -------------------------
# Parse YYYY-MM-DD string → UNIX timestamp
# -------------------------
func parse_date_to_unix(date_str: String) -> int:
	var parts = date_str.split("-")
	var dt_dict = {
		"year": int(parts[0]),
		"month": int(parts[1]),
		"day": int(parts[2]),
		"hour": 0,
		"minute": 0,
		"second": 0
	}
	return Time.get_unix_time_from_datetime_dict(dt_dict)

# -------------------------
# Convert UNIX → YYYY-MM-DD string
# -------------------------
func unix_to_date_string(unix_time: int) -> String:
	var dt = Time.get_datetime_dict_from_unix_time(unix_time) # UTC dictionary
	return "%04d-%02d-%02d" % [dt.year, dt.month, dt.day]

# -------------------------
# Add days to UNIX timestamp
# -------------------------
func add_days(unix_time: int, days: int) -> int:
	return unix_time + days * 86400

# -------------------------
# Main Calculation
# -------------------------
func calculate_book_info():
	var issue_unix = parse_date_to_unix(issue_date)
	var now_unix = Time.get_unix_time_from_system() # Current UNIX time (UTC)
	
	# Days kept (floor division)
	days_kept = int((now_unix - issue_unix) / 86400)
	
	# Due date
	var due_unix = add_days(issue_unix, allowed_days)
	due_date = unix_to_date_string(due_unix)
	
	# Fine
	if days_kept > allowed_days:
		fine_amount = (days_kept - allowed_days) * fine_per_day
	else:
		fine_amount = 0

	print_book_info()

# -------------------------
# Print info
# -------------------------
func print_book_info():
	print("-----------------------------")
	print("Book:", book_name)
	print("Author:", author)
	print("Taken Out By:", taken_out_by)
	print("Issued:", issue_date)
	print("Due:", due_date)
	print("Days Kept:", days_kept)
	print("Fine: R", fine_amount)
	print("-----------------------------")
	
	#have a signal and of specific books
#	emit these and keep track so the new misson can be printed
	
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

	print("Picked up cup")


func check_book_for_first_npc() -> bool:
	var correct_name = "Animal Farm"
	var correct_author = "George Orwell"

	if book_name.strip_edges().to_lower() == correct_name.to_lower() \
	and author.strip_edges().to_lower() == correct_author.to_lower():
		print("Correct book entered.")
		#Global.check_book_first_npc = true
		return true
	else:
		print("Wrong book.")
		return false
