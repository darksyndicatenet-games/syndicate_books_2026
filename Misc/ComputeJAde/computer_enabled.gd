extends Node3D

@onready var misson_manager: Node = $"../MissonManager"

@onready var sprite_2d: TextureRect = $CanvasLayer/User
@onready var error_message: Label = $CanvasLayer/ErrorMessage
@onready var user: TextureRect = $CanvasLayer/User

var cursor_visible: bool = false
var player_in_range: bool = false
var cam_is_enable: bool = false
var interacting: bool = false  # Track if player is interacting


var prompted_Beginning := false


func _ready() -> void:
	user.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_focus_next"):  # Tab
		cursor_visible = not cursor_visible
		if cursor_visible:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	# Only open computer if NOT interacting
	if player_in_range and not interacting and Input.is_action_just_pressed("place"):
		start_interaction()
		prompt_message_when_player_interacts_computer()

func start_interaction() -> void:
	interacting = true
	sprite_2d.visible = true
	#entry_list.visible = true
	# Show cursor when interacting

	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	Global.player_exited_the_screen = false
	Global.lock_all_player_controls_ = false
	# Switch to computer camera if available
	#if computer_camera:
		#computer_camera.current = true

func end_interaction() -> void:
	interacting = false
	sprite_2d.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Global.player_exited_the_screen = true
	Global.lock_all_player_controls_ = true
		#computer_camera.current = false
func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		player_in_range = true
		

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.name == "Player":
		player_in_range = false
		
func prompt_message_when_player_interacts_computer():
	misson_manager.set_message("log the books in")

	
