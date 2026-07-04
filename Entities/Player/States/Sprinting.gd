extends PlayerState

@export var sprint_speed: float = 10.0

func enter(_previous_state_path: String, _data := {}) -> void:
	# Set base speed on our movement component
	player.movement_component.current_speed = sprint_speed
	
func update(_delta: float) -> void:
	# Handle normal state changes (falling/idle)
	if not player.is_on_floor():
		finished.emit(FALLING)
		return
	if player.movement_component.get_movement_direction() == Vector3.ZERO:
		finished.emit(IDLE)
		return
		
	# Transition to Sprint or Crouch
	if not player.input_component.is_sprinting:
		finished.emit(RUNNING)
	elif player.input_component.is_crouching:
		finished.emit(CROUCHING)
		
func handle_input(event: InputEvent) -> void:
	if player.input_component.is_jumping:
		finished.emit(JUMPING, {"speed": sprint_speed})
		return
