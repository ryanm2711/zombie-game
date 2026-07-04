class_name PathfindingComponent extends Node3D

@export var navigation_agent_3d: NavigationAgent3D

@export var turn_speed: float = 8.0

var _starting_position: Vector3
var _target_position: Vector3

signal on_pathfinding_change(currentPos: Vector3, nextPos: Vector3)

func _ready() -> void:
	navigation_agent_3d.path_desired_distance = 0.5
	navigation_agent_3d.target_desired_distance = 0.5
	
	_target_position = owner.global_position
	_starting_position = _target_position
	
func _physics_process(delta: float) -> void:
	if navigation_agent_3d.is_navigation_finished():
		return
		
	var current_pos: Vector3 = global_position
	var next_path_pos: Vector3 = navigation_agent_3d.get_next_path_position()
	var target_angle := atan2(current_pos.x - next_path_pos.x, current_pos.z - next_path_pos.z)
	
	# Flip 180 degrees
	target_angle += PI
	
	if owner:
		owner.rotation.y = lerp_angle(owner.rotation.y, target_angle, turn_speed * delta)
	
	if current_pos != next_path_pos:
		on_pathfinding_change.emit(current_pos, next_path_pos)
	
func actor_setup() -> void:
	await get_tree().physics_frame
	set_target_position(_target_position)
	
func set_target_position(pos: Vector3) -> void:
	if _target_position != pos:
		navigation_agent_3d.set_target_position(pos)
