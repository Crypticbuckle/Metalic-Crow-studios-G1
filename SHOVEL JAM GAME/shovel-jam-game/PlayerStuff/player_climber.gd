extends CharacterBody2D

class_name player_climber

var move_speed : int = 180

@export var arm_left : arm_element
@export var arm_right : arm_element
@export var sprite_manager : player_sprite_manager

@onready var Jump_AudioPlayer : AudioStreamPlayer = %JumpAudio
@onready var camera : Camera2D = %Camera2D

var can_input : bool = true

var time_count : float = 0.0

var equal_point : Vector2 = Vector2.ZERO

var level : String = "uid://gxx41fnr170f"


func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	
	time_count += delta
	$CanvasLayer/N4.text = str( "%02d : %02d" % [(time_count)/60, int(time_count)%60] )
	
	
	gravity_stuff(delta)
	move_and_slide()
	
	if arm_left and arm_right:
		if arm_left.is_hooked or arm_right.is_hooked:
			equal_point = (arm_left.hand_area.global_position + arm_right.hand_area.global_position)/2
			global_position += global_position.direction_to(equal_point) * delta * global_position.distance_to(equal_point) * 10
			
			if velocity.y >= 150:
				velocity.y = 150
		
		if Input.is_action_just_pressed("ESC"):
			get_tree().change_scene_to_file("uid://barea3iqtfcyk")
			
		if can_input:
			if Input.is_action_pressed("Left"):
				global_position.x -= delta * move_speed
			elif Input.is_action_pressed("Right"):
				global_position.x += delta * move_speed



func _process(_delta: float) -> void:
	var progress = []
	ResourceLoader.load_threaded_get_status(level, progress)
	
	if progress[0] == 1:
		var packed_scene : PackedScene = ResourceLoader.load_threaded_get(level)
		get_tree().change_scene_to_packed(packed_scene)



func kill():
	can_input = false
	sprite_manager.death()
	arm_left.queue_free()
	arm_right.queue_free()
	await get_tree().create_timer(3.5).timeout
	ResourceLoader.load_threaded_request(level)


func gravity_stuff(delta):
	if !is_on_floor():
		velocity.y += 980 * delta
	
	if can_input:
		if Input.is_action_just_pressed("Space"):
			if is_on_floor() or (arm_left.is_hooked or arm_right.is_hooked):
				Jump_AudioPlayer.pitch_scale = randf_range(0.85, 1.15)
				Jump_AudioPlayer.play()
				velocity.y = -360
