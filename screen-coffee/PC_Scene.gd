extends StaticBody3D
class_name PCStatic

var player:Player
var is_using:bool = false

@onready var camera_3d: Camera3D = $Camera3Dvar
@onready var subview_port: SubViewport = $SubViewport
@onready var pc_control: Control = $"SubViewport/PC Control"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")

func toggle_use():
	is_using = !is_using
	camera_3d.current = is_using

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if !is_using:
		return
	
	if event is InputEventKey:
		if Input.is_action_just_pressed("ui_cancel"):
			toggle_use()
			player.input_locked = false
		else:
			subview_port.push_input(event)
		
			
	if event is InputEventMouseButton:
		# move mouse with button events in subview port
		if event.button_index == MOUSE_BUTTON_LEFT or event.button_index == MOUSE_BUTTON_MIDDLE or event.button_index == MOUSE_BUTTON_RIGHT:
			var mouse_event = InputEventMouseButton.new()
			mouse_event.button_index = event.button_index
			mouse_event.pressed = event.pressed
			mouse_event.position = pc_control.pc_mouse_pos
			mouse_event.global_position = pc_control.pc_mouse_pos
			
			subview_port.push_input(mouse_event)
			
	elif event is InputEventMouseMotion:
		# move mouse in subview port
		pc_control.pc_mouse_pos += event.relative
		pc_control.pc_mouse_pos.x = clamp(pc_control.pc_mouse_pos.x, 0.0, subview_port.size.x - 10.0)
		pc_control.pc_mouse_pos.y = clamp(pc_control.pc_mouse_pos.y, 0.0, subview_port.size.y - 10.0)
		pc_control.update_cursor_pos()
		
