extends Node2D

class_name title_menu


@onready var Grab_AudioPlayer : AudioStreamPlayer = %GrabAudio


var level : String = "uid://gxx41fnr170f"



func _ready() -> void:
	pass




func _on_start_button_button_down() -> void:
	Grab_AudioPlayer.pitch_scale = randf_range(0.65, 1.35)
	Grab_AudioPlayer.play()
	
	$CanvasLayer/ColorRect/AnimationPlayer.play("Fade")
	await get_tree().create_timer(0.65).timeout
	
	
	ResourceLoader.load_threaded_request(level)


func _process(_delta: float) -> void:
	var progress = []
	ResourceLoader.load_threaded_get_status(level, progress)
	
	if progress[0] == 1:
		var packed_scene : PackedScene = ResourceLoader.load_threaded_get(level)
		get_tree().change_scene_to_packed(packed_scene)


func _on_exit_button_button_down() -> void:
	get_tree().quit()
