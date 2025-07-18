extends Node2D

class_name arm_element


@export var is_left : bool

@export var parent : player_climber



@onready var hand_area : Area2D = %HandArea
@onready var Bottom_Area : Area2D = %BottomArea
@onready var Top_Area : Area2D = %TopArea
@onready var Hands_Sprite : AnimatedSprite2D = %HandsSprite
@onready var Grab_AudioPlayer : AudioStreamPlayer = %GrabAudio


var wanted_hand_pos : Vector2 = Vector2.ZERO

var is_hooked : bool = false
var hook_point : Vector2 = Vector2.ZERO

var holding_shovel : bool = false



func _ready() -> void:
	close_hand()



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
	
	
	
	if holding_shovel:
		close_hand()
	
	
	
	#checks what hand this is, and uses the right input
	if parent.can_input:
		shovel_detection()
		#shovel grab detection
		
		if is_left:
			if Input.is_action_pressed("LMB"):
				clicked_down()
			
			
			if Input.is_action_just_released("LMB"):
				hook_check()
				close_hand()
			
			
		elif !is_left:
			if Input.is_action_pressed("RMB"):
				clicked_down()
			
			
			if Input.is_action_just_released("RMB"):
				hook_check()
				close_hand()



func shovel_detection():
	#stuff for picking up the shovel
	if Input.is_action_just_pressed("F_key"):
		if hand_area.get_overlapping_bodies():
			clicked_down()
			var shovel_thing : shovel_item = hand_area.get_overlapping_bodies()[0]
			if shovel_thing.current_slot == 3:
				shovel_thing.pick_up(is_left)



#checks if hook is applicable, and then does it
func hook_check():
	if !Top_Area.has_overlapping_bodies():
		if Bottom_Area.has_overlapping_bodies():
			hook_point = hand_area.global_position
			is_hooked = true
			$HandArea/GrabParticles.emitting = true
			Grab_AudioPlayer.pitch_scale = randf_range(0.65, 1.35)
			Grab_AudioPlayer.play()




func open_hand():
	if !holding_shovel:
		if is_left:
			Hands_Sprite.frame = 3
		else:
			Hands_Sprite.frame = 1


func close_hand():
	if is_left:
		Hands_Sprite.frame = 2
	else:
		Hands_Sprite.frame = 0




func clicked_down():
	#sets the wanted hand position to be in the direction of the mouse, with a limit of whatever
	
	open_hand()
	
	is_hooked = false
	
	var local_mouse_pos = get_local_mouse_position()
	wanted_hand_pos = local_mouse_pos
	wanted_hand_pos = wanted_hand_pos.limit_length(70)
