extends CenterContainer

class_name Dialogue_Box



@onready var label : RichTextLabel = $RichTextLabel
@onready var text_timer : Timer = $Timer
@onready var anim_player : AnimationPlayer = $AnimationPlayer
@onready var player : player_climber = get_tree().get_first_node_in_group("Player")



var heights : Array[int] = [0, -500, -10000000000]

var dialogue : Dictionary = {
	0 : "poo",
	-500 : "poo again",
	
	
}

var next_height : int




func _ready() -> void:
	next_height = heights.pop_front()



func _process(_delta: float) -> void:
	if player.global_position.y <= next_height:
		enqueue_text(dialogue.get(next_height))



func enqueue_text(new_text):
	anim_player.play("FadeIn")
	if heights:
		next_height = heights.pop_front()
	
	label.text = new_text
	$Timer.start(1 + float(len(new_text))/5)



func _on_timer_timeout() -> void:
	anim_player.play_backwards("FadeIn")
