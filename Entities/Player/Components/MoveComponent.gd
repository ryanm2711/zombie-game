class_name MoveComponent extends Node3D

@export var entity: CharacterBody3D
@export var jump_power: float = 4.5
@export var is_player_controlled: bool = false

@export var noclip_speed: float = 15.0

var current_speed: float = 0.0
var _current_move_dir := Vector3.ZERO

var _is_noclipping: bool

func set_movement_direction(dir: Vector3):
	if _current_move_dir != dir:
		_current_move_dir = dir

func get_movement_direction() -> Vector3:
	return _current_move_dir
	
func apply_jump() -> void:
	if entity:
		entity.velocity.y += jump_power
	
func _physics_process(delta: float) -> void:
	if GameManager.is_game_paused():
		return
	
	if not entity:
		return
		
	if _is_noclipping and is_player_controlled:
		_do_noclip(delta)
		return
		
	var target_speed = current_speed
		
	# Apply gravity
	if not entity.is_on_floor():
		target_speed /= 2
		entity.velocity.y += GameManager.GRAVITY * delta
		
	# Calculate direction relative to entity orientation
	var direction = Vector3.ZERO
	if is_player_controlled: # Convert local coordinates to world
		direction = (entity.transform.basis * _current_move_dir.normalized())
	else:
		# This is for AI, which already is using world coordinates
		direction = _current_move_dir.normalized()
		
	if direction:
		entity.velocity.x = direction.x * target_speed
		entity.velocity.z = direction.z * target_speed
	else:
		entity.velocity.x = move_toward(entity.velocity.x, 0, target_speed)
		entity.velocity.z = move_toward(entity.velocity.z, 0, target_speed)
		
	entity.move_and_slide()
	
func _on_input_component_on_movement_input_change(direction: Vector2) -> void:
	var current_dir := get_movement_direction()
	set_movement_direction(Vector3(direction.x, current_dir.y, direction.y))
	
func _on_input_component_noclip_pressed() -> void:
	if not entity:
		return
		
	_is_noclipping = !_is_noclipping
	
	var collider = entity.get_node_or_null("CollisionShape3D") as CollisionShape3D
	if _is_noclipping:
		entity.velocity = Vector3.ZERO # Reset velocity
		if collider:
			collider.disabled = true
			
	else:
		if collider:
			collider.disabled = false

func _do_noclip(delta: float) -> void:
	# Get camera so we can base our move direction from it
	var camera = entity.get_viewport().get_camera_3d()
	if not camera: 
		return
	
	# Get the current world coordinates of camera
	var cam_basis: Basis = camera.global_transform.basis
	
	# Allow player to fly up and down via space and prone keys
	var up_down_axis := 0.0
	if Input.is_action_pressed("jump"): 
		up_down_axis += 1.0
	if Input.is_action_pressed("prone"):    
		up_down_axis -= 1.0
	
	# Combine horizontal WASD vectors relative to camera direction
	var fly_direction := Vector3.ZERO
	fly_direction += cam_basis.x * _current_move_dir.x # Strafe Right/Left
	fly_direction += cam_basis.z * _current_move_dir.z # Fly Forward/Backward
	fly_direction += Vector3.UP * up_down_axis         # Fly Up/Down
	
	# Set new pos
	entity.global_position += fly_direction.normalized() * noclip_speed * delta
