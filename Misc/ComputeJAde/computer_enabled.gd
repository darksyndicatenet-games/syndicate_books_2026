extends Node3D

@onready var sprite_2d: TextureRect = $CanvasLayer/User

@onready var error_message: Label = $CanvasLayer/ErrorMessage

@onready var user: TextureRect = $CanvasLayer/User

var cursor_visible: bool = false
var player_in_range: bool = false
var cam_is_enable: bool = false
var interacting: bool = false  # Track if player is interacting

func _ready() -> void:
	user.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#error_message.visible = false

#func _process(delta: float) -> void:
	#if player_in_range and Input.is_action_just_pressed("interact") and not interacting:
		#start_interaction()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_focus_next"):  # Tab key
		cursor_visible = not cursor_visible  # toggle the flag
		if cursor_visible:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
	if player_in_range and Input.is_action_just_pressed("place"):
		if not interacting:
			start_interaction()
		else:
			end_interaction()

func start_interaction() -> void:
	interacting = true
	sprite_2d.visible = true
	# Show cursor when interacting

	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	# Switch to computer camera if available
	#if computer_camera:
		#computer_camera.current = true

func end_interaction() -> void:
	interacting = false
	sprite_2d.visible = false
	# Hide cursor and return to player camera
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#if computer_camera:
		#computer_camera.current = false



func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		player_in_range = true
		

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.name == "Player":
		player_in_range = false
