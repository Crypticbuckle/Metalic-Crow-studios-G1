extends Node2D


func _ready() -> void:
	await get_tree().create_timer(21.0).timeout
	get_tree().change_scene_to_file("uid://barea3iqtfcyk")
