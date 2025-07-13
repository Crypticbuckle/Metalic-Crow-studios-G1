extends StaticBody2D

class_name shovel_item


@onready var col_area : Area2D = $Area2D
@onready var ray_cast : RayCast2D = $RayCast2D

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


func _ready() -> void:
	current_slot = 3
	set_collision_layer_value(3, false)



func _physics_process(delta: float) -> void:
	inputs(delta)
	
	shovel_placement()


func shovel_placement():
	match current_slot:
		0:
			global_position = player.global_position
		1:
			global_position = LHand.hand_area.global_position
		2:
			global_position = RHand.hand_area.global_position


func inputs(delta):
	
	if Input.is_action_pressed("Rotate"):
		if current_slot == 1 or current_slot == 2:
			rotate(delta*3)
	
	
	
	
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
					set_collision_layer_value(3, true)


func pick_up(is_left_hand):
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
