extends StaticBody2D

class_name shovel_item


@onready var col_area : Area2D = $Area2D
@onready var ray_cast : RayCast2D = $RayCast2D

@onready var player : player_climber = get_tree().get_first_node_in_group("Player")
@onready var LHand : arm_element = get_tree().get_first_node_in_group("Hand")


var is_stuck : bool = true
var can_detect : bool = false
var on_back : bool = false

var current_hand : arm_element



func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	if !is_stuck:
		if Input.is_action_pressed("Rotate") and !on_back:
			rotate(delta*3)
		
		if Input.is_action_just_pressed("F_key"):
			if !on_back:
				on_back = true
				ray_cast.enabled = false
				can_detect = false
			
		if on_back:
			if Input.is_action_just_pressed("E_Key"):
				on_back = false
				pick_up(get_tree().get_first_node_in_group("RIGHTHAND"))
			if Input.is_action_just_pressed("Q_Key"):
				on_back = false
				pick_up(get_tree().get_first_node_in_group("LEFTHAND"))
	
	
	if current_hand:
		global_position = current_hand.hand_area.global_position
	if on_back:
		global_position = player.global_position
	
	
	if ray_cast.is_colliding():
		if can_detect:
			if Input.is_action_pressed("LMB") or Input.is_action_pressed("RMB"):
				is_stuck = true
				ray_cast.enabled = false
				current_hand = null
				set_collision_layer_value(3, true)
	
	if !ray_cast.is_colliding():
		if (!can_detect) and (!on_back):
			
			can_detect = true


func pick_up(hand):
	set_collision_layer_value(3, false)
	current_hand = hand
	is_stuck = false
	ray_cast.enabled = true
	can_detect = false
