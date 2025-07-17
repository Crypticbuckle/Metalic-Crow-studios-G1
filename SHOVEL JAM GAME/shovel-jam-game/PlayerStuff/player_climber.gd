extends CharacterBody2D

class_name player_climber

var move_speed : int = 180

@export var arm_left : arm_element
@export var arm_right : arm_element

@onready var Jump_AudioPlayer : AudioStreamPlayer = %JumpAudio

var equal_point : Vector2 = Vector2.ZERO


func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	gravity_stuff(delta)
	move_and_slide()
	
	if arm_left.is_hooked or arm_right.is_hooked:
		equal_point = (arm_left.hand_area.global_position + arm_right.hand_area.global_position)/2
		global_position += global_position.direction_to(equal_point) * delta * global_position.distance_to(equal_point) * 10
		
		if velocity.y >= 150:
			velocity.y = 150
	
	
	if Input.is_action_just_pressed("ESC"):
		get_tree().change_scene_to_file("uid://barea3iqtfcyk")
	
	
	if Input.is_action_pressed("Right"):
		global_position.x += delta * move_speed
	if Input.is_action_pressed("Left"):
		global_position.x -= delta * move_speed



func kill():
	get_tree().call_deferred("reload_current_scene")



func gravity_stuff(delta):
	if !is_on_floor():
		velocity.y += 980 * delta
	
	
	if Input.is_action_just_pressed("Space"):
		if is_on_floor() or (arm_left.is_hooked or arm_right.is_hooked):
			Jump_AudioPlayer.pitch_scale = randf_range(0.85, 1.15)
			Jump_AudioPlayer.play()
			velocity.y = -360
