extends PlayerState

@export var speed_in_air: float = 4.5

func enter(_previous_state_path: String, _data := {}) -> void:
	# Trigger the actual physics jump on our component
	player.movement_component.current_speed = speed_in_air
	player.movement_component.apply_jump()
	
func physics_update(_delta: float) -> void:
	# If upward velocity stops or goes negative, we are now falling
	if player.velocity.y <= 0:
		finished.emit(FALLING)
		return
