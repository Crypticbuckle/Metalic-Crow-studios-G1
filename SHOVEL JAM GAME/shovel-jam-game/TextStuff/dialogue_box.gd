extends CenterContainer

class_name Dialogue_Box



@onready var label : RichTextLabel = $RichTextLabel
@onready var text_timer : Timer = $Timer
@onready var anim_player : AnimationPlayer = $AnimationPlayer
@onready var audio_player : AudioStreamPlayer = $AudioStreamPlayer
@onready var player : player_climber = get_tree().get_first_node_in_group("Player")



var fading_out : bool = false



var heights : Array[int] = [-200, -1300, -1700, -2100, -2500, -4000, -6500, -10000000000]

var dialogue : Dictionary = {
	heights[0] : "Get started. You have much to climb.",
	heights[1] : "Many join the dead during their attempt to honor them. None were left to honor these ones.",
	heights[2] : "The shovel. Using the tools of my parasites in this way? Resourceful. Defiant.",
	heights[3] : "The shovel is attuned to the earth. If it is stuck above you, call it back with R",
	heights[4] : "A terrible miasma chases you. While you were born from me, it is born from them. From their dead.",
	heights[5] : "This cavern is nothing compared to those above. Stare long enough upwards, and it may faintly emulate the sky",
	heights[6] : "Observe. They carved their fissures through me. Now you alone remain to make this pilgrimege upwards",
	
	
}

var next_height : int




func _ready() -> void:
	hide()
	anim_player.play_backwards("FadeIn")
	next_height = heights.pop_front()
	
	await get_tree().create_timer(1.0).timeout
	show()



func _process(delta: float) -> void:
	if player.global_position.y <= next_height:
		enqueue_text(dialogue.get(next_height))
	
	
	if fading_out:
		audio_player.volume_db -= delta*8
		if audio_player.volume_db <= -16.0:
			audio_player.stop()
			fading_out = false



func enqueue_text(new_text):
	anim_player.play("FadeIn")
	if heights:
		next_height = heights.pop_front()
	
	label.text = new_text
	audio_player.volume_db = 0.0
	audio_player.play(randf_range(0.0, 15))
	audio_player.pitch_scale = randf_range(0.90, 1.25)
	$Timer.start(1 + float(len(new_text))/15)



func _on_timer_timeout() -> void:
	fading_out = true
	anim_player.play_backwards("FadeIn")
