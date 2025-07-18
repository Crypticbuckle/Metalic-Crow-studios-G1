extends Area2D

class_name camera_trigger


var camera : Camera2D
@export var wanted_local_pos : Vector2

@onready var music_bg_manager : AudioStreamPlayer = get_tree().get_first_node_in_group("MusicPlayer")

var credits : String = "uid://bht3cdj844xs8"

var fade : bool = false


func _physics_process(delta: float) -> void:
	if camera:
		camera.global_position = lerp(camera.global_position, to_global(wanted_local_pos), delta*12)
		music_bg_manager.volume_db = move_toward(music_bg_manager.volume_db, -24, delta*6)
	
	if fade:
		$ColorRect.color.a = move_toward($ColorRect.color.a, 1, delta/5)
		wanted_local_pos.y -= delta*40



func _process(_delta: float) -> void:
	var progress = []
	ResourceLoader.load_threaded_get_status(credits, progress)
	
	if progress[0] == 1:
		var packed_scene : PackedScene = ResourceLoader.load_threaded_get(credits)
		get_tree().change_scene_to_packed(packed_scene)



func _on_body_entered(body: player_climber) -> void:
	camera = body.camera
	
	await get_tree().create_timer(0.5).timeout
	
	body.can_input = false
	
	await get_tree().create_timer(3.5).timeout
	
	fade = true
	
	await get_tree().create_timer(6).timeout
	
	ResourceLoader.load_threaded_request(credits)
