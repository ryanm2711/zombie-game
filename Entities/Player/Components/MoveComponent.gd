class_name MoveComponent extends Node3D

@export var entity: CharacterBody3D

@export var jump_power: float = 4.5

@export var is_player_controlled: bool = false

var current_speed: float = 0.0
var _current_move_dir := Vector3.ZERO

func set_movement_direction(dir: Vector3):
	if _current_move_dir != dir:
		_current_move_dir = dir

func get_movement_direction() -> Vector3:
	return _current_move_dir
	
func apply_jump() -> void:
	if entity:
		entity.velocity.y += jump_power
	
func _physics_process(delta: float) -> void:
	if not entity:
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
