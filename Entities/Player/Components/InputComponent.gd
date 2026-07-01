class_name InputComponent extends Node3D

signal on_movement_input_change(direction: Vector2)
signal on_camera_input_change(relative_motion: Vector2)
signal jump_pressed

signal attack_pressed
signal attack_released
signal reload_weapon

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		on_camera_input_change.emit(event.relative)
		
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			else:
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
				
	if event.is_action_pressed("jump"):
		jump_pressed.emit()
		
	if event.is_action_pressed("primaryattack"):
		attack_pressed.emit()
	elif event.is_action_released("primaryattack"):
		attack_released.emit()
		
	if event.is_action_pressed("reload"):
		reload_weapon.emit()
	
func _process(_delta: float) -> void:
	var move_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	on_movement_input_change.emit(move_dir)
