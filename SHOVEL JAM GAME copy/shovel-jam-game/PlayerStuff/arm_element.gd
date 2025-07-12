extends Node2D

class_name arm_element


@export var is_left : bool



@onready var hand_area : Area2D = %HandArea
@onready var Bottom_Area : Area2D = %BottomArea
@onready var Top_Area : Area2D = %TopArea


var wanted_hand_pos : Vector2 = Vector2.ZERO

var is_hooked : bool = false
var hook_point : Vector2 = Vector2.ZERO


func _ready() -> void:
	pass



func _physics_process(delta: float) -> void:
	
	
	#moves the hand to the wanted position
	hand_area.position = lerp(hand_area.position, wanted_hand_pos, delta*8)
	
	
	#resets wanted position to base
	if !is_hooked:
		wanted_hand_pos = Vector2.ZERO
	else:
		wanted_hand_pos = to_local(hook_point)
		hand_area.position = wanted_hand_pos
	
	
	
	if Input.is_action_just_pressed("Space"):
		hook_point = Vector2.ZERO
		is_hooked = false
		#removes hook point when jumping
	
	
	
	
	
	#checks what hand this is, and uses the right input
	if is_left:
		if Input.is_action_pressed("LMB"):
			clicked_down()
		
		
		if Input.is_action_just_released("LMB"):
			hook_check()
		
	elif !is_left:
		if Input.is_action_pressed("RMB"):
			clicked_down()
		
		
		if Input.is_action_just_released("RMB"):
			hook_check()



#checks if hook is applicable, and then does it
func hook_check():
	if Bottom_Area.has_overlapping_bodies():
		if !Top_Area.has_overlapping_areas():
			hook_point = hand_area.global_position
			is_hooked = true




func clicked_down():
	#sets the wanted hand position to be in the direction of the mouse, with a limit of whatever
	
	is_hooked = false
	
	var local_mouse_pos = get_local_mouse_position()
	wanted_hand_pos = local_mouse_pos
	wanted_hand_pos = wanted_hand_pos.limit_length(75)
