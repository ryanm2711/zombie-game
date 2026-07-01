extends PlayerState

@export var speed_in_air: float = 4.5

func enter(_previous_state_path: String, _data := {}) -> void:
	# Set base speed on our movement component
	player.movement_component.current_speed = speed_in_air

func physics_update(_delta: float) -> void:
	# Once we hit the floor, decide whether we are idling or running
	if player.is_on_floor():
		var move_dir = player.movement_component.get_movement_direction()
		if move_dir.length_squared() > 0.001:
			finished.emit(RUNNING)
		else:
			finished.emit(IDLE)
		return
