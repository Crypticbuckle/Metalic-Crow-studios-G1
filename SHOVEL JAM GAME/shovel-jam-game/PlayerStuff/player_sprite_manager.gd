extends Node2D

class_name player_sprite_manager

@export var parent : player_climber

@onready var sprite_anim : AnimatedSprite2D = $AnimatedSprite2D

var jumping : bool = false

var dead : bool = false




func _ready() -> void:
	pass


func _physics_process(_delta: float) -> void:
	
	if parent.can_input:
		
		if (parent.arm_left.is_hooked) or (parent.arm_right.is_hooked):
			z_index = 0
			jumping = false
			sprite_anim.flip_h = false
			sprite_anim.play("Hooked")
		
		
		elif parent.is_on_floor():
			z_index = 3
			jumping = false
			
			if Input.is_action_pressed("Left"):
				sprite_anim.play("Running")
				sprite_anim.flip_h = false
			elif Input.is_action_pressed("Right"):
				sprite_anim.play("Running")
				sprite_anim.flip_h = true
			else:
				sprite_anim.play("Idle")
		
		else:
			if Input.is_action_pressed("Left"):
				sprite_anim.flip_h = false
			elif Input.is_action_pressed("Right"):
				sprite_anim.flip_h = true
			
			if !jumping:
				z_index = 3
				sprite_anim.play("Jump")
				jumping = true
	
	else:
		z_index = 3
		jumping = false
		if !dead:
			sprite_anim.play("Idle")



func death():
	dead = true
	sprite_anim.play("Death")
