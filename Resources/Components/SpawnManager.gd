class_name SpawnManager extends Node

@export var enemy_scenes: Array[PackedScene]
@export var spawn_points_node: Node
@export var spawn_timer: Timer

@export_category("Settings")
@export var auto_spawn: bool
@export var max_active_spawn: int = 24
@export var max_total_spawn: int = -1

var _spawn_points: Array[Marker3D] = []
var _current_spawn_count: int = 0
var _total_spawn_count: int = 0

signal on_all_enemies_cleared

func _ready() -> void:
	for child in spawn_points_node.get_children():
		if child is Marker3D:
			_spawn_points.append(child)
			
	# Validation check
	if _spawn_points.is_empty():
		push_error("SpawnManager: No Marker3D children found!")
		return
		
	if enemy_scenes.is_empty():
		push_warning("SpawnManager: No enemy scenes assigned in the inspector.")
		
func spawn_random_enemy() -> void:
	if enemy_scenes.is_empty() or _spawn_points.is_empty() or _current_spawn_count == max_active_spawn or _total_spawn_count == max_total_spawn:
		return
	
	# Pick a random enemy scene from the array
	var random_enemy_scene: PackedScene = enemy_scenes.pick_random()
	
	# Pick a random Marker3D from the gathered spawn points
	var random_marker: Marker3D = _spawn_points.pick_random()
	
	# Instantiate the enemy
	var enemy_instance = random_enemy_scene.instantiate()
	enemy_instance.tree_exited.connect(_on_spawned_enemy_destroyed)
	
	add_child(enemy_instance)
	
	# Set the enemy's global position and rotation to match the chosen Marker3D
	enemy_instance.global_transform = random_marker.global_transform
	
	_current_spawn_count += 1
	_total_spawn_count += 1
	
func _on_spawned_enemy_destroyed():
	_current_spawn_count -= 1
	
	if _current_spawn_count == 0:
		on_all_enemies_cleared.emit()
		_total_spawn_count = 0
		
func _on_spawn_timer_timeout() -> void:
	if auto_spawn and not GameManager.is_game_paused():
		spawn_random_enemy()
