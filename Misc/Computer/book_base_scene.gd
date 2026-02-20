extends RigidBody3D

@export var book_name: String
@export var author: String
@export var taken_out_by: String
@export var issue_date: String = "2025-01-01" # YYYY-MM-DD
@export var fine_per_day: float = 2.0

var allowed_days := 14
var days_kept := 0
var fine_amount := 0.0
var due_date: String = ""


func _ready():
	calculate_book_info()
	self.set_meta("display_name",book_name)


# -------------------------
#  PARSE YYYY-MM-DD string
# -------------------------
func parse_date(date_str: String) -> int:
	var parts = date_str.split("-")
	var year = int(parts[0])
	var month = int(parts[1])
	var day = int(parts[2])

	# Convert to UNIX time (seconds since 1970)
	return Time.get_unix_time_from_datetime_dict({
		"year": year,
		"month": month,
		"day": day,
		"hour": 0,
		"minute": 0,
		"second": 0
	})


# -------------------------
#  ADD days to UNIX time
# -------------------------
func add_days(unix_time: int, days: int) -> int:
	return unix_time + (days * 86400)


# -------------------------
#  MAIN CALCULATION
# -------------------------
func calculate_book_info():
	var issue_unix := parse_date(issue_date)
	var now_unix := Time.get_unix_time_from_system()

	# Days kept
	days_kept = int((now_unix - issue_unix) / 86400)

	# Due date
	var due_unix := add_days(issue_unix, allowed_days)
	due_date = convert_unix_to_date_string(due_unix)

	# Fine
	if days_kept > allowed_days:
		fine_amount = (days_kept - allowed_days) * fine_per_day
	else:
		fine_amount = 0

	# Debug print
	print_book_info()

# -------------------------
#  Convert UNIX → YYYY-MM-DD
# -------------------------
func convert_unix_to_date_string(unix_time: int) -> String:
	var d = Time.get_datetime_dict_from_unix_time(unix_time)
	return "%04d-%02d-%02d" % [d.year, d.month, d.day]


# -------------------------
#  Print info (for testing)
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
