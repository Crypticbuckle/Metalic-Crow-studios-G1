extends StaticBody2D

class_name shovel_item


@onready var col_area : Area2D = $Area2D
@onready var ray_cast : RayCast2D = $RayCast2D
@onready var Drive_AudioPlayer : AudioStreamPlayer = %DriveSound

@onready var player : player_climber = get_tree().get_first_node_in_group("Player")
@onready var RHand : arm_element = get_tree().get_first_node_in_group("RIGHTHAND")
@onready var LHand : arm_element = get_tree().get_first_node_in_group("LEFTHAND")


var current_slot : int = 0
#I should use an ENUM for this but I can't be asked lol
#1 -> left hand
#2 -> right hand
#3 -> placed down
#0 -> back

var can_stab : bool = true

var first_picked_up : bool = false


func _ready() -> void:
	current_slot = 3
	set_collision_layer_value(3, false)



func _physics_process(delta: float) -> void:
	inputs(delta)
	
	shovel_placement(delta)


func shovel_placement(delta):
	match current_slot:
		0:
			global_position = lerp(global_position, player.global_position, delta*30)
		1:
			global_position = lerp(global_position, LHand.hand_area.global_position, delta*30)
		2:
			global_position = lerp(global_position, RHand.hand_area.global_position, delta*30)

func inputs(delta):
	
	if Input.is_action_pressed("Rotate"):
		if current_slot == 1 or current_slot == 2:
			rotate(delta*3)
		
		elif global_position.y < player.global_position.y:
			if first_picked_up:
				change_slot(0)
	
	
	
	
	if Input.is_action_just_pressed("Q_Key"):
		if current_slot == 1:
			change_slot(0)
			LHand.holding_shovel = false
			
		elif current_slot == 0 or current_slot == 2:
			change_slot(1)
			RHand.holding_shovel = false
			LHand.holding_shovel = true
	
	
	
	
	if Input.is_action_just_pressed("E_Key"):
		if current_slot == 2:
			change_slot(0)
			RHand.holding_shovel = false
			
		elif current_slot == 0 or current_slot == 1:
			change_slot(2)
			LHand.holding_shovel = false
			RHand.holding_shovel = true
	
	
	
	
	if Input.is_action_pressed("F_key"):
		if current_slot == 1 or current_slot == 2:
			if can_stab:
				ray_cast.enabled = true
				if ray_cast.is_colliding():
					
					if current_slot == 1:
						LHand.holding_shovel = false
					if current_slot == 2:
						RHand.holding_shovel = false
					
					current_slot = 3
					Drive_AudioPlayer.pitch_scale = randf_range(0.75, 1.25)
					Drive_AudioPlayer.play()
					set_collision_layer_value(3, true)


func pick_up(is_left_hand):
	first_picked_up = true
	can_stab = false
	$StabTimer.start()
	set_collision_layer_value(3, false)
	if is_left_hand:
		current_slot = 1
		LHand.holding_shovel = true
	else:
		current_slot = 2
		RHand.holding_shovel = true


func change_slot(new_slot):
	current_slot = new_slot


func _on_stab_timer_timeout() -> void:
	ray_cast.enabled = true
	if !ray_cast.is_colliding():
		can_stab = true
	else:
		$StabTimer.start()
