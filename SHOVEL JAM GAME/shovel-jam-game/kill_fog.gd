extends Node2D
class_name Kill_fog


@onready var player : player_climber = get_tree().get_first_node_in_group("Player")

@export var speeds_and_heights : Array[Vector2]

var speed_counter : int = 0

var current_speed : float = 0

var debug_hidden : bool = false



func _ready() -> void:
	debug_hidden = true
	$CanvasLayer.hide()



func _physics_process(delta: float) -> void:
	
	
	if speeds_and_heights.size() > (speed_counter):
		if player.global_position.y <= speeds_and_heights[speed_counter].y:
			$CPUParticles2D2.emitting = true
			current_speed = speeds_and_heights[speed_counter].x
			speed_counter += 1
	
	
	debug_stuff()
	
	
	if Input.is_action_just_pressed("Space"):
		$CPUParticles2D.emitting = true
	
	
	
	global_position.y -= current_speed * delta
	global_position.x = player.global_position.x
	
	
#checks if player has crossed damage zone


func player_entered_fog(body) -> void:
	if body == player:
		player.kill()


func debug_stuff():
	if Input.is_action_just_pressed("T_Key"):
		if debug_hidden:
			debug_hidden = false
			$CanvasLayer.show()
		else:
			debug_hidden = true
			$CanvasLayer.hide()
	
	$CanvasLayer/VBoxContainer2/N1.text = str( snapped(player.global_position.y, 0.01) )
	$CanvasLayer/VBoxContainer2/N2.text = str( snapped(global_position.y, 0.01) )
	$CanvasLayer/VBoxContainer2/N3.text = str( current_speed )
