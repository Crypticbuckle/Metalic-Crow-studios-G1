extends Node2D
class_name Kill_fog

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Space"):
		$GPUParticles2D.emitting=true
	position.y -= 20 * delta
#checks if player has crossed damage zone
func player_entered_fog(body) -> void:
	if body == Global.player:
		print('player has entered Take damage')
