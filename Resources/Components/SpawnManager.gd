class_name SpawnManager extends Node3D

# Drag and drop your enemy scene(s) into the Inspector
@export var enemy_scenes: Array[PackedScene]

@export var spawn_points_node: Node3D

@export var _spawn_timer: Timer

# Optional: Automatically spawn on a timer
@export_category("Settings")
@export var spawn_cooldown: float = 2.0
@export var auto_spawn: bool = true
@export var max_spawn: int = 5

var _spawn_points: Array[Marker3D] = []
var _spawned_enemies: int = 0

func _ready() -> void:
	# 1. Gather all Marker3D children automatically
	for child in spawn_points_node.get_children():
		if child is Marker3D:
			_spawn_points.append(child)
			
	# Validation check
	if _spawn_points.is_empty():
		push_error("SpawnManager: No Marker3D children found!")
		return
		
	if enemy_scenes.is_empty():
		push_warning("SpawnManager: No enemy scenes assigned in the inspector.")

	# 2. Set up the auto-spawn timer if enabled
	if auto_spawn:
		setup_timer()

func setup_timer() -> void:
	_spawn_timer.wait_time = spawn_cooldown
	_spawn_timer.timeout.connect(spawn_random_enemy)
	_spawn_timer.start()

# Call this function to spawn an enemy at a random location
func spawn_random_enemy() -> void:
	if enemy_scenes.is_empty() or _spawn_points.is_empty() or _spawned_enemies == max_spawn:
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
	
	_spawned_enemies += 1

func _on_spawned_enemy_destroyed():
	_spawned_enemies -= 1
