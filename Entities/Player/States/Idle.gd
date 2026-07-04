extends PlayerState

func update(_delta: float) -> void:
	if not player.is_on_floor():
		finished.emit(FALLING)
		return
	
	if player.movement_component.get_movement_direction().length_squared() > 0.001:
		finished.emit(RUNNING)
		return
		
	if player.input_component.is_crouching:
		finished.emit(CROUCHING)
		return

func handle_input(event: InputEvent) -> void:
	if player.input_component.is_jumping and player.is_on_floor():
		finished.emit(JUMPING)
