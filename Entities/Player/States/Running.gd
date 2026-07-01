extends PlayerState

@export var run_speed: float = 5.0

func enter(_previous_state_path: String, _data := {}) -> void:
	# Set base speed on our movement component
	player.movement_component.current_speed = run_speed

func update(_delta: float) -> void:
	# Handle normal state changes (falling/idle)	
	if not player.is_on_floor():
		finished.emit(FALLING)
		return
	if player.movement_component.get_movement_direction() == Vector3.ZERO:
		finished.emit(IDLE)
		return

func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		finished.emit(JUMPING)
		return
		
	if Input.is_action_pressed("sprint"):
		finished.emit(SPRINTING)
		return
	elif Input.is_action_pressed("crouch"):
		finished.emit(CROUCHING)
		return
