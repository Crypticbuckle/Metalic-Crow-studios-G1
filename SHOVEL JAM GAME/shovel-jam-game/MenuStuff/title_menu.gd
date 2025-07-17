extends Node2D

class_name title_menu


@onready var level : PackedScene = preload("uid://gxx41fnr170f")
@onready var Grab_AudioPlayer : AudioStreamPlayer = %GrabAudio



func _ready() -> void:
	pass




func _on_start_button_button_down() -> void:
	Grab_AudioPlayer.pitch_scale = randf_range(0.65, 1.35)
	Grab_AudioPlayer.play()
	
	$CanvasLayer/ColorRect/AnimationPlayer.play("Fade")
	await get_tree().create_timer(0.65).timeout
	
	get_tree().change_scene_to_packed(level)
